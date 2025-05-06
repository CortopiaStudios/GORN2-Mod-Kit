// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Threading;
using Cortopia.Scripts.Reactivity.Utils;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;
using UnityEngine.Events;
using UnityEngine.InputSystem;

namespace Cortopia.Scripts.Reactivity
{
    public static class ReactiveExtensions
    {
        public static Reactive<ArraySnapshot<T>> Combine<T>(this IEnumerable<Reactive<T>> reactives)
        {
            return new Reactive<ArraySnapshot<T>>(new Combinator<T>(reactives));
        }

        public static Reactive<(T, T2)> Combine<T, T2>(this Reactive<T> reactive, Reactive<T2> other)
        {
            return new Reactive<(T, T2)>(new Combinator<T, T2>(reactive.Source, other.Source));
        }

        public static Reactive<(T, T2, T3)> Combine<T, T2, T3>(this Reactive<T> reactive, Reactive<T2> other, Reactive<T3> other2)
        {
            return new Reactive<(T, T2, T3)>(new Combinator<T, T2, T3>(reactive.Source, other.Source, other2.Source));
        }

        public static Reactive<(T, T2, T3, T4)> Combine<T, T2, T3, T4>(this Reactive<T> reactive, Reactive<T2> other, Reactive<T3> other2, Reactive<T4> other3)
        {
            return new Reactive<(T, T2, T3, T4)>(new Combinator<T, T2, T3, T4>(reactive.Source, other.Source, other2.Source, other3.Source));
        }

        public static Reactive<T2> Select<T, T2>(this Reactive<T> reactive, [NotNull] Func<T, T2> selector)
        {
            return new Reactive<T2>(new Selector<T, T2>(reactive.Source, selector));
        }

        public static Reactive<T3> Select<T, T2, T3>(this Reactive<(T, T2)> reactive, [NotNull] Func<T, T2, T3> selector)
        {
            return new Reactive<T3>(new Selector<(T, T2), T3>(reactive.Source, t => selector(t.Item1, t.Item2)));
        }

        public static Reactive<T4> Select<T, T2, T3, T4>(this Reactive<(T, T2, T3)> reactive, [NotNull] Func<T, T2, T3, T4> selector)
        {
            return new Reactive<T4>(new Selector<(T, T2, T3), T4>(reactive.Source, t => selector(t.Item1, t.Item2, t.Item3)));
        }

        public static Reactive<T5> Select<T, T2, T3, T4, T5>(this Reactive<(T, T2, T3, T4)> reactive, [NotNull] Func<T, T2, T3, T4, T5> selector)
        {
            return new Reactive<T5>(new Selector<(T, T2, T3, T4), T5>(reactive.Source, t => selector(t.Item1, t.Item2, t.Item3, t.Item4)));
        }

        public static Reactive<T> DistinctUntilChanged<T>(this Reactive<T> reactive)
        {
            return new Reactive<T>(new DistinctFilter<T>(reactive.Source));
        }

        public static Reactive<T> Switch<T>(this Reactive<Reactive<T>> reactive)
        {
            return new Reactive<T>(new Switcher<T>(reactive.Source));
        }

        public static Reactive<T> ToReactive<T>(this UnityEvent<T> unityEvent, Func<T> getter = null)
        {
            return new Reactive<T>(new ReactiveUnityEvent<T>(unityEvent, getter ?? (() => default(T))));
        }

        public static Reactive<IntegerCounter> ToReactiveEvent(this UnityEvent unityEvent)
        {
            return new Reactive<IntegerCounter>(new ReactiveUnityEvent(unityEvent));
        }

        public static Reactive<(IntegerCounter trigger, T data)> ToReactiveEvent<T>(this UnityEvent<T> unityEvent)
        {
            return new Reactive<(IntegerCounter trigger, T data)>(new ReactiveCounterUnityEvent<T>(unityEvent));
        }

        public static Reactive<T> ToReactive<T>(this UniTask<T> asyncValue, T initial = default)
        {
            var reactiveSource = new ReactiveSource<T>(initial);
            _ = SetAsync(reactiveSource, asyncValue);
            return reactiveSource.Reactive;
        }

        public static Reactive<T> ToReactive<T>(this IUniTaskAsyncEnumerable<T> asyncEnumerable, T initial = default)
        {
            return new Reactive<T>(new ReactiveAsyncEnumerable<T>(asyncEnumerable, initial));
        }

        public static Reactive<bool> ToReactive(this UniTask asyncValue)
        {
            var reactiveSource = new ReactiveSource<bool>(false);
            _ = SetAsyncTrue(reactiveSource, asyncValue);
            return reactiveSource.Reactive;
        }

        public static Reactive<(InputAction.CallbackContext, InputAction.CallbackContext)> ToReactive(this InputAction action)
        {
            return Reactive.FromEvent<InputAction.CallbackContext>(h => action.performed += h, h => action.performed -= h)
                .Combine(Reactive.FromEvent<InputAction.CallbackContext>(h => action.canceled += h, h => action.canceled -= h));
        }

        public static Reactive<bool> ToReactivePressed(this InputAction action)
        {
            return Reactive.FromEvent<InputAction.CallbackContext>(h => action.started += h, h => action.started -= h)
                .Combine(Reactive.FromEvent<InputAction.CallbackContext>(h => action.canceled += h, h => action.canceled -= h))
                .Select((startContext, endContext) => startContext.started && !endContext.canceled);
        }

        /// <summary>
        ///     Creates a task that finished when reactive fulfills a certain condition
        /// </summary>
        public static async UniTask<T> ToTaskWhen<T>(this Reactive<T> reactive, Func<T, bool> condition, CancellationToken cancellationToken = default)
        {
            await foreach (T value in reactive.WithCancellation(cancellationToken))
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (condition(value))
                {
                    return value;
                }
            }

            throw new InvalidOperationException(); // Unreachable
        }

        /// <summary>
        ///     Creates a task that finished the NEXT time the counter is incremented
        /// </summary>
        public static async UniTask<IntegerCounter> ToTask(this Reactive<IntegerCounter> reactive, CancellationToken cancellationToken = default)
        {
            return await ToTask(reactive, reactive.Value.CounterValue, cancellationToken);
        }

        /// <summary>
        ///     Creates a task that finished the NEXT time the counter is incremented
        /// </summary>
        public static async UniTask<IntegerCounter> ToTask(this Reactive<IntegerCounter> reactive, uint initial, CancellationToken cancellationToken = default)
        {
            await foreach (IntegerCounter value in reactive.WithCancellation(cancellationToken))
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (value.CounterValue != initial)
                {
                    return value;
                }
            }

            throw new InvalidOperationException(); // Unreachable
        }

        /// <summary>
        ///     Creates a task that finished the NEXT time the counter is incremented
        /// </summary>
        public static async UniTask<T> ToTask<T>(this Reactive<(IntegerCounter, T)> reactive, CancellationToken cancellationToken = default)
        {
            uint initial = reactive.Value.Item1.CounterValue;
            await foreach ((IntegerCounter counter, T value) in reactive.WithCancellation(cancellationToken))
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (counter.CounterValue != initial)
                {
                    return value;
                }
            }

            throw new InvalidOperationException(); // Unreachable
        }

        /// <summary>
        ///     Creates a task that finished when reactive fulfills a certain condition the NEXT time the counter is incremented
        /// </summary>
        public static async UniTask<T> ToTaskWhenEvent<T>(
            this Reactive<(IntegerCounter, T)> reactive, Func<T, bool> condition, CancellationToken cancellationToken = default)
        {
            uint initial = reactive.Value.Item1.CounterValue;
            await foreach ((IntegerCounter counter, T value) in reactive.WithCancellation(cancellationToken))
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (counter.CounterValue != initial && condition(value))
                {
                    return value;
                }
            }

            throw new InvalidOperationException(); // Unreachable
        }

        private static async UniTaskVoid SetAsync<T>(ReactiveSource<T> reactiveSource, UniTask<T> asyncValue)
        {
            reactiveSource.Value = await asyncValue;
        }

        private static async UniTaskVoid SetAsyncTrue(ReactiveSource<bool> reactiveSource, UniTask asyncValue)
        {
            await asyncValue;
            reactiveSource.Value = true;
        }

        public static Reactive<T> Lazy<T>(Func<T> get, Func<Reactive<T>> subscribe, Action unsubscribe = null)
        {
            return new Reactive<T>(new LazyReactive<T>(get, subscribe, unsubscribe));
        }

        public static Reactive<Unit> FromEvent(Action<Action> addHandler, Action<Action> removeHandler)
        {
            return new Reactive<Unit>(new EventHandler(addHandler, removeHandler));
        }

        public static Reactive<T> FromEvent<T>(Action<Action<T>> addHandler, Action<Action<T>> removeHandler, T initial = default)
        {
            return new Reactive<T>(new EventHandler<T>(addHandler, removeHandler, initial));
        }

        public static Reactive<IntegerCounter> Merge(this Reactive<IntegerCounter> a, Reactive<IntegerCounter> b)
        {
            return new Reactive<IntegerCounter>(new Merger(a.Source, b.Source));
        }

        public static Reactive<(IntegerCounter, T)> Merge<T>(this Reactive<(IntegerCounter, T)> a, Reactive<(IntegerCounter, T)> b, Func<T, T, T> funcAb = null)
        {
            return new Reactive<(IntegerCounter, T)>(new Merger<T, T, T>(a.Source, b.Source, x => x, x => x, funcAb ?? ((x, _) => x)));
        }

        public static Reactive<(IntegerCounter, T)> Merge<T, T1, T2>(
            this Reactive<(IntegerCounter, T1)> a, Reactive<(IntegerCounter, T2)> b, [NotNull] Func<T1, T> funcA, [NotNull] Func<T2, T> funcB,
            [NotNull] Func<T1, T2, T> funcAb)
        {
            return new Reactive<(IntegerCounter, T)>(new Merger<T, T1, T2>(a.Source, b.Source, funcA, funcB, funcAb));
        }

        public static Reactive<(IntegerCounter, T)> Apply<T>(this Reactive<IntegerCounter> reactiveEvent, Reactive<T> reactiveValue)
        {
            return reactiveEvent.Select(x => (x, reactiveValue.Value));
        }

        public static Reactive<(IntegerCounter, (T1, T2))> Apply<T1, T2>(this Reactive<(IntegerCounter, T1)> reactiveEvent, Reactive<T2> reactiveValue)
        {
            return reactiveEvent.Select(x => (x.Item1, (x.Item2, reactiveValue.Value)));
        }

        public static Reactive<(IntegerCounter, (T1, T2, T3))> Apply<T1, T2, T3>(
            this Reactive<(IntegerCounter, T1)> reactiveEvent, Reactive<T2> reactiveValueA, Reactive<T3> reactiveValueB)
        {
            return reactiveEvent.Select(x => (x.Item1, (x.Item2, reactiveValueA.Value, reactiveValueB.Value)));
        }

        public static Reactive<(IntegerCounter, (T1, T2, T3, T4))> Apply<T1, T2, T3, T4>(
            this Reactive<(IntegerCounter, T1)> reactiveEvent, Reactive<T2> reactiveValueA, Reactive<T3> reactiveValueB, Reactive<T4> reactiveValueC)
        {
            return reactiveEvent.Select(x => (x.Item1, (x.Item2, reactiveValueA.Value, reactiveValueB.Value, reactiveValueC.Value)));
        }

        public static DisposableUnityEvent AsEvent(this Reactive<IntegerCounter> reactive)
        {
            uint? prev = null;
            return new DisposableUnityEvent(unityEvent => reactive.OnValue(x =>
            {
                if (prev != x.CounterValue)
                {
                    prev = x.CounterValue;
                    unityEvent.Invoke();
                }
            }));
        }

        public static DisposableUnityEvent<T> AsEvent<T>(this Reactive<(IntegerCounter, T)> reactive)
        {
            uint? prev = null;
            return new DisposableUnityEvent<T>(unityEvent => reactive.OnValue(x =>
            {
                if (prev != x.Item1.CounterValue)
                {
                    prev = x.Item1.CounterValue;
                    unityEvent.Invoke(x.Item2);
                }
            }));
        }

        private abstract class CombinatorBase : ReactiveBase, IReactiveHandler
        {
            private int _changing;
            protected bool Changed { get; private set; }

            public new void OnValueChanging()
            {
                this._changing++;
                if (this._changing > 1)
                {
                    return;
                }

                this.Changed = false;
                base.OnValueChanging();
            }

            public new void OnValueChanged()
            {
                this.Changed = true;
                this._changing--;

                if (this._changing > 0)
                {
                    return;
                }

                base.OnValueChanged();
            }

            public new void OnValueChangeCancelled()
            {
                this._changing--;

                if (this._changing > 0)
                {
                    return;
                }

                if (this.Changed)
                {
                    base.OnValueChanged();
                }
                else
                {
                    base.OnValueChangeCancelled();
                }
            }
        }

        private sealed class Combinator<T> : CombinatorBase, IReactiveSource<ArraySnapshot<T>>, IReactiveHandler
        {
            [NotNull]
            private readonly ReactiveSubscription[] _reactiveSubscriptions;

            [NotNull]
            private readonly IReactiveSource<T>[] _sources;
            private readonly VersionedList<T> _versionedValueList;
            private bool _isDirty = true;

            public Combinator([NotNull] IEnumerable<Reactive<T>> reactives)
            {
                var sourceList = new List<IReactiveSource<T>>();
                foreach (var reactive in reactives ?? throw new ArgumentNullException(nameof(reactives)))
                {
                    sourceList.Add(reactive.Source);
                }

                this._sources = sourceList.ToArray();
                this._reactiveSubscriptions = new ReactiveSubscription[this._sources.Length];
                this._versionedValueList = new VersionedList<T>(this._sources.Length);
                for (int i = 0; i < this._sources.Length; i++)
                {
                    this._versionedValueList.List.Add(default(T));
                }
            }

            public new void OnValueChanging()
            {
                base.OnValueChanging();
                this._isDirty = true;
            }

            public new void OnValueChangeCancelled()
            {
                this._isDirty = false;
                base.OnValueChangeCancelled();
            }

            public ArraySnapshot<T> Value
            {
                get
                {
                    if (this._isDirty)
                    {
                        this._versionedValueList.InvalidateSnapshots();

                        for (int i = 0; i < this._sources.Length; i++)
                        {
                            this._versionedValueList.List[i] = this._sources[i].Value;
                        }

                        this._isDirty = !this.HasHandlers;
                    }

                    return new ArraySnapshot<T>(this._versionedValueList);
                }
            }

            protected override void Subscribe()
            {
                for (int i = 0; i < this._sources.Length; i++)
                {
                    this._reactiveSubscriptions[i] = this._sources[i].OnValueUpdate(this);
                }
            }

            protected override void UnSubscribe()
            {
                foreach (ReactiveSubscription subscription in this._reactiveSubscriptions)
                {
                    subscription.Dispose();
                }

                this._isDirty = true;
            }
        }

        private sealed class Combinator<T, T2> : CombinatorBase, IReactiveSource<(T, T2)>
        {
            [NotNull]
            private readonly IReactiveSource<T2> _other;

            [NotNull]
            private readonly IReactiveSource<T> _reactive;

            private ReactiveSubscription _reactiveSubscription1;
            private ReactiveSubscription _reactiveSubscription2;

            public Combinator([NotNull] IReactiveSource<T> reactive, [NotNull] IReactiveSource<T2> other)
            {
                this._reactive = reactive ?? throw new ArgumentNullException(nameof(reactive));
                this._other = other ?? throw new ArgumentNullException(nameof(other));
            }

            public (T, T2) Value => (this._reactive.Value, this._other.Value);

            protected override void Subscribe()
            {
                this._reactiveSubscription1 = this._reactive.OnValueUpdate(this);
                this._reactiveSubscription2 = this._other.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription1.Dispose();
                this._reactiveSubscription2.Dispose();
            }
        }

        private sealed class Combinator<T, T2, T3> : CombinatorBase, IReactiveSource<(T, T2, T3)>
        {
            [NotNull]
            private readonly IReactiveSource<T2> _other;

            [NotNull]
            private readonly IReactiveSource<T3> _other2;

            [NotNull]
            private readonly IReactiveSource<T> _reactive;

            private ReactiveSubscription _reactiveSubscription1;
            private ReactiveSubscription _reactiveSubscription2;
            private ReactiveSubscription _reactiveSubscription3;

            public Combinator([NotNull] IReactiveSource<T> reactive, [NotNull] IReactiveSource<T2> other, [NotNull] IReactiveSource<T3> other2)
            {
                this._reactive = reactive ?? throw new ArgumentNullException(nameof(reactive));
                this._other = other ?? throw new ArgumentNullException(nameof(other));
                this._other2 = other2 ?? throw new ArgumentNullException(nameof(other2));
            }

            public (T, T2, T3) Value => (this._reactive.Value, this._other.Value, this._other2.Value);

            protected override void Subscribe()
            {
                this._reactiveSubscription1 = this._reactive.OnValueUpdate(this);
                this._reactiveSubscription2 = this._other.OnValueUpdate(this);
                this._reactiveSubscription3 = this._other2.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription1.Dispose();
                this._reactiveSubscription2.Dispose();
                this._reactiveSubscription3.Dispose();
            }
        }

        private sealed class Combinator<T, T2, T3, T4> : CombinatorBase, IReactiveSource<(T, T2, T3, T4)>
        {
            [NotNull]
            private readonly IReactiveSource<T2> _other;

            [NotNull]
            private readonly IReactiveSource<T3> _other2;

            [NotNull]
            private readonly IReactiveSource<T4> _other3;

            [NotNull]
            private readonly IReactiveSource<T> _reactive;

            private ReactiveSubscription _reactiveSubscription1;
            private ReactiveSubscription _reactiveSubscription2;
            private ReactiveSubscription _reactiveSubscription3;
            private ReactiveSubscription _reactiveSubscription4;

            public Combinator(
                [NotNull] IReactiveSource<T> reactive, [NotNull] IReactiveSource<T2> other, [NotNull] IReactiveSource<T3> other2, [NotNull] IReactiveSource<T4> other3)
            {
                this._reactive = reactive ?? throw new ArgumentNullException(nameof(reactive));
                this._other = other ?? throw new ArgumentNullException(nameof(other));
                this._other2 = other2 ?? throw new ArgumentNullException(nameof(other2));
                this._other3 = other3 ?? throw new ArgumentNullException(nameof(other3));
            }

            public (T, T2, T3, T4) Value => (this._reactive.Value, this._other.Value, this._other2.Value, this._other3.Value);

            protected override void Subscribe()
            {
                this._reactiveSubscription1 = this._reactive.OnValueUpdate(this);
                this._reactiveSubscription2 = this._other.OnValueUpdate(this);
                this._reactiveSubscription3 = this._other2.OnValueUpdate(this);
                this._reactiveSubscription4 = this._other3.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription1.Dispose();
                this._reactiveSubscription2.Dispose();
                this._reactiveSubscription3.Dispose();
                this._reactiveSubscription4.Dispose();
            }
        }

        private sealed class Selector<T, T2> : ReactiveBase, IReactiveSource<T2>, IReactiveHandler
        {
            [NotNull]
            private readonly IReactiveSource<T> _reactive;

            [NotNull]
            private readonly Func<T, T2> _selector;

            private bool _isDirty = true;
            private ReactiveSubscription _reactiveSubscription;
            private T2 _value;

            public Selector([NotNull] IReactiveSource<T> reactive, [NotNull] Func<T, T2> selector)
            {
                this._reactive = reactive ?? throw new ArgumentNullException(nameof(reactive));
                this._selector = selector ?? throw new ArgumentNullException(nameof(selector));
            }

            public new void OnValueChanging()
            {
                base.OnValueChanging();
                this._isDirty = true;
            }

            public new void OnValueChangeCancelled()
            {
                this._isDirty = false;
                base.OnValueChangeCancelled();
            }

            public T2 Value
            {
                get
                {
                    if (this._isDirty)
                    {
                        this._value = this._selector(this._reactive.Value);
                        this._isDirty = !this.HasHandlers;
                    }

                    return this._value;
                }
            }

            protected override void Subscribe()
            {
                this._reactiveSubscription = this._reactive.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription.Dispose();
                this._isDirty = true;
            }
        }

        private sealed class DistinctFilter<T> : ReactiveBase, IReactiveSource<T>, IReactiveHandler
        {
            [NotNull]
            private readonly IReactiveSource<T> _reactiveSource;

            private bool _isDirty = true;

            private T _lastValue;
            private ReactiveSubscription _reactiveSubscription;

            public DistinctFilter([NotNull] IReactiveSource<T> reactiveSource)
            {
                this._reactiveSource = reactiveSource ?? throw new ArgumentNullException(nameof(reactiveSource));
            }

            public new void OnValueChanging()
            {
                base.OnValueChanging();
                this._isDirty = true;
            }

            public new void OnValueChangeCancelled()
            {
                this._isDirty = false;
                base.OnValueChangeCancelled();
            }

            public new void OnValueChanged()
            {
                this._isDirty = false;
                T value = this._reactiveSource.Value;
                if (!EqualityComparer<T>.Default.Equals(value, this._lastValue))
                {
                    this._lastValue = value;
                    base.OnValueChanged();
                }
                else
                {
                    this.OnValueChangeCancelled();
                }
            }

            public T Value => this._isDirty ? this._reactiveSource.Value : this._lastValue;

            protected override void Subscribe()
            {
                this._reactiveSubscription = this._reactiveSource.OnValueUpdate(this);
                this._lastValue = this._reactiveSource.Value;
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription.Dispose();
                this._isDirty = true;
            }
        }

        private sealed class Switcher<T> : ReactiveBase, IReactiveSource<T>, IReactiveHandler
        {
            private readonly IReactiveSource<Reactive<T>> _reactiveSource;
            private ReactiveSubscription _innerSubscription;
            private ReactiveSubscription _reactiveSubscription;

            public Switcher([NotNull] IReactiveSource<Reactive<T>> reactiveSource)
            {
                this._reactiveSource = reactiveSource ?? throw new ArgumentNullException(nameof(reactiveSource));
            }

            public new void OnValueChanged()
            {
                this._innerSubscription.Dispose();
                base.OnValueChanged();
                this._innerSubscription = this._reactiveSource.Value.Source.OnValueUpdate(new InnerHandler(this));
            }

            public T Value => this._reactiveSource.Value.Source.Value;

            protected override void Subscribe()
            {
                this._reactiveSubscription = this._reactiveSource.OnValueUpdate(this);
                this._innerSubscription = this._reactiveSource.Value.Source.OnValueUpdate(new InnerHandler(this));
            }

            protected override void UnSubscribe()
            {
                this._innerSubscription.Dispose();
                this._reactiveSubscription.Dispose();
            }

            private readonly struct InnerHandler : IReactiveHandler
            {
                private readonly ReactiveTrigger _trigger;

                public InnerHandler(ReactiveTrigger trigger)
                {
                    this._trigger = trigger;
                }

                public void OnValueChanging()
                {
                    this._trigger.OnValueChanging();
                }

                public void OnValueChanged()
                {
                    this._trigger.OnValueChanged();
                }

                public void OnValueChangeCancelled()
                {
                    this._trigger.OnValueChangeCancelled();
                }
            }
        }

        private sealed class ReactiveAsyncEnumerable<T> : ReactiveBase, IReactiveSource<T>, IReactiveHandler
        {
            private readonly IUniTaskAsyncEnumerable<T> _asyncEnumerable;
            private CancellationTokenSource _cancellation;

            public ReactiveAsyncEnumerable(IUniTaskAsyncEnumerable<T> asyncEnumerable, T initial)
            {
                this._asyncEnumerable = asyncEnumerable;
                this.Value = initial;
            }

            public T Value { get; private set; }

            protected override void Subscribe()
            {
                this._cancellation = new CancellationTokenSource();
                this.Run(this._asyncEnumerable.WithCancellation(this._cancellation.Token)).SuppressCancellationThrow().Forget();
            }

            private async UniTask Run(UniTaskCancelableAsyncEnumerable<T> enumerable)
            {
                await foreach (T value in enumerable)
                {
                    this.OnValueChanging();
                    this.Value = value;
                    this.OnValueChanged();
                }
            }

            protected override void UnSubscribe()
            {
                this._cancellation.Cancel();
                this._cancellation = null;
            }
        }

        private sealed class ReactiveUnityEvent : ReactiveBase, IReactiveSource<IntegerCounter>
        {
            private readonly UnityAction _unityAction;
            private readonly UnityEvent _unityEvent;
            private IDisposable _subscription;

            public ReactiveUnityEvent([NotNull] UnityEvent unityEvent)
            {
                this._unityEvent = unityEvent ?? throw new ArgumentNullException(nameof(unityEvent));
                this._unityAction = this.Handler;
            }

            public IntegerCounter Value { get; private set; }

            private void Handler()
            {
                this.OnValueChanging();
                this.Value = this.Value.Incremented;
                this.OnValueChanged();
            }

            protected override void Subscribe()
            {
                this._unityEvent.AddListener(this._unityAction);
            }

            protected override void UnSubscribe()
            {
                this._unityEvent.RemoveListener(this._unityAction);
            }
        }

        private sealed class ReactiveCounterUnityEvent<T> : ReactiveBase, IReactiveSource<(IntegerCounter trigger, T data)>
        {
            private readonly UnityAction<T> _unityAction;
            private readonly UnityEvent<T> _unityEvent;
            private IDisposable _subscription;

            public ReactiveCounterUnityEvent([NotNull] UnityEvent<T> unityEvent)
            {
                this._unityEvent = unityEvent ?? throw new ArgumentNullException(nameof(unityEvent));
                this._unityAction = this.Handler;
            }

            public (IntegerCounter trigger, T data) Value { get; private set; }

            private void Handler(T callback)
            {
                this.OnValueChanging();
                this.Value = (this.Value.trigger.Incremented, callback);
                this.OnValueChanged();
            }

            protected override void Subscribe()
            {
                this._unityEvent.AddListener(this._unityAction);
            }

            protected override void UnSubscribe()
            {
                this._unityEvent.RemoveListener(this._unityAction);
            }
        }

        private sealed class ReactiveUnityEvent<T> : ReactiveBase, IReactiveSource<T>
        {
            private readonly Func<T> _getter;
            private readonly UnityAction<T> _unityAction;
            private readonly UnityEvent<T> _unityEvent;
            private IDisposable _subscription;

            private T _value;

            public ReactiveUnityEvent([NotNull] UnityEvent<T> unityEvent, Func<T> getter)
            {
                this._unityEvent = unityEvent ?? throw new ArgumentNullException(nameof(unityEvent));
                this._getter = getter;
                this._unityAction = this.Handler;
            }

            public T Value => this.HasHandlers ? this._value : this._getter();

            private void Handler(T callback)
            {
                this.OnValueChanging();
                this._value = callback;
                this.OnValueChanged();
            }

            protected override void Subscribe()
            {
                this._value = this._getter();
                this._unityEvent.AddListener(this._unityAction);
            }

            protected override void UnSubscribe()
            {
                this._unityEvent.RemoveListener(this._unityAction);
            }
        }

        private sealed class LazyReactive<T> : ReactiveBase, IReactiveSource<T>, IReactiveHandler
        {
            private readonly Func<T> _get;
            private readonly Func<Reactive<T>> _subscribe;
            private readonly Action _unsubscribe;
            private Reactive<T>? _reactive;
            private ReactiveSubscription _subscription;

            public LazyReactive([NotNull] Func<T> get, [NotNull] Func<Reactive<T>> subscribe, Action unsubscribe = null)
            {
                this._get = get ?? throw new ArgumentNullException(nameof(get));
                this._subscribe = subscribe ?? throw new ArgumentNullException(nameof(subscribe));
                this._unsubscribe = unsubscribe;
            }

            public T Value => this._reactive.HasValue ? this._reactive.Value.Value : this._get();

            protected override void Subscribe()
            {
                var reactive = this._subscribe();
                this._reactive = reactive;
                this._subscription = reactive.Source.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._subscription.Dispose();
                this._unsubscribe?.Invoke();
                this._reactive = null;
            }
        }

        private sealed class EventHandler : ReactiveBase, IReactiveSource<Unit>, IReactiveHandler
        {
            private readonly Action<Action> _addHandler;
            private readonly Action<Action> _removeHandler;

            public EventHandler(Action<Action> addHandler, Action<Action> removeHandler)
            {
                this._addHandler = addHandler;
                this._removeHandler = removeHandler;
            }

            public Unit Value => default;

            private void Handler()
            {
                this.OnValueChanging();
                this.OnValueChanged();
            }

            protected override void Subscribe()
            {
                this._addHandler(this.Handler);
            }

            protected override void UnSubscribe()
            {
                this._removeHandler(this.Handler);
            }
        }

        private sealed class EventHandler<T> : ReactiveBase, IReactiveSource<T>, IReactiveHandler
        {
            private readonly Action<Action<T>> _addHandler;
            private readonly Action<Action<T>> _removeHandler;

            public EventHandler(Action<Action<T>> addHandler, Action<Action<T>> removeHandler, T initial = default)
            {
                this._addHandler = addHandler;
                this._removeHandler = removeHandler;
                this.Value = initial;
            }

            public T Value { get; private set; }

            private void Handler(T value)
            {
                this.OnValueChanging();
                this.Value = value;
                this.OnValueChanged();
            }

            protected override void Subscribe()
            {
                this._addHandler(this.Handler);
            }

            protected override void UnSubscribe()
            {
                this._removeHandler(this.Handler);
            }
        }

        private class Merger : CombinatorBase, IReactiveHandler, IReactiveSource<IntegerCounter>
        {
            [NotNull]
            private readonly IReactiveSource<IntegerCounter> _reactiveA;
            private readonly IReactiveSource<IntegerCounter> _reactiveB;
            private uint? _prevA;
            private uint? _prevB;

            private ReactiveSubscription _reactiveSubscription;

            public Merger([NotNull] IReactiveSource<IntegerCounter> reactiveA, [NotNull] IReactiveSource<IntegerCounter> reactiveB)
            {
                this._reactiveA = reactiveA ?? throw new ArgumentNullException(nameof(reactiveA));
                this._reactiveB = reactiveB ?? throw new ArgumentNullException(nameof(reactiveB));
            }

            public new void OnValueChanged()
            {
                if (!this.Changed)
                {
                    uint a = this._reactiveA.Value.CounterValue;
                    uint b = this._reactiveB.Value.CounterValue;
                    if (this._prevA != a || this._prevB != b)
                    {
                        this._prevA = a;
                        this._prevB = b;
                        this.Value = this.Value.Incremented;
                    }
                }

                base.OnValueChanged();
            }

            public IntegerCounter Value { get; private set; }

            protected override void Subscribe()
            {
                this._reactiveSubscription = this._reactiveA.OnValueUpdate(this) & this._reactiveB.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription.Dispose();
                this._prevA = null;
                this._prevB = null;
            }
        }

        private class Merger<T, T1, T2> : CombinatorBase, IReactiveHandler, IReactiveSource<(IntegerCounter, T)>
        {
            [NotNull]
            private readonly Func<T1, T> _funcA;
            [NotNull]
            private readonly Func<T1, T2, T> _funcAb;
            [NotNull]
            private readonly Func<T2, T> _funcB;
            [NotNull]
            private readonly IReactiveSource<(IntegerCounter, T1)> _reactiveA;
            private readonly IReactiveSource<(IntegerCounter, T2)> _reactiveB;
            private uint? _prevA;
            private uint? _prevB;

            private ReactiveSubscription _reactiveSubscription;

            public Merger(
                [NotNull] IReactiveSource<(IntegerCounter, T1)> reactiveA, [NotNull] IReactiveSource<(IntegerCounter, T2)> reactiveB, [NotNull] Func<T1, T> funcA,
                [NotNull] Func<T2, T> funcB, [NotNull] Func<T1, T2, T> funcAb)
            {
                this._reactiveA = reactiveA ?? throw new ArgumentNullException(nameof(reactiveA));
                this._reactiveB = reactiveB ?? throw new ArgumentNullException(nameof(reactiveB));
                this._funcA = funcA ?? throw new ArgumentNullException(nameof(funcA));
                this._funcB = funcB ?? throw new ArgumentNullException(nameof(funcB));
                this._funcAb = funcAb ?? throw new ArgumentNullException(nameof(funcAb));
            }

            public new void OnValueChanged()
            {
                if (!this.Changed)
                {
                    (IntegerCounter, T1) aValue = this._reactiveA.Value;
                    (IntegerCounter, T2) bValue = this._reactiveB.Value;
                    uint a = aValue.Item1.CounterValue;
                    uint b = bValue.Item1.CounterValue;
                    bool aChanged = this._prevA != a;
                    bool bChanged = this._prevB != b;
                    if (aChanged)
                    {
                        this._prevA = a;
                        if (bChanged)
                        {
                            this._prevB = b;
                            this.Value = (this.Value.Item1.Incremented, this._funcAb(aValue.Item2, bValue.Item2));
                        }
                        else
                        {
                            this.Value = (this.Value.Item1.Incremented, this._funcA(aValue.Item2));
                        }
                    }
                    else if (bChanged)
                    {
                        this._prevB = b;
                        this.Value = (this.Value.Item1.Incremented, this._funcB(bValue.Item2));
                    }
                }

                base.OnValueChanged();
            }

            public (IntegerCounter, T) Value { get; private set; }

            protected override void Subscribe()
            {
                this._reactiveSubscription = this._reactiveA.OnValueUpdate(this) & this._reactiveB.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._reactiveSubscription.Dispose();
                this._prevA = null;
                this._prevB = null;
            }
        }
    }
}