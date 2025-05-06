// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Threading;
using Cortopia.Scripts.Reactivity.Utils;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Reactivity
{
    public static class Reactive
    {
        public static Reactive<T> FromTask<T>(UniTask<T> asyncValue, T initial = default)
        {
            return asyncValue.ToReactive(initial);
        }

        public static Reactive<T> Constant<T>(T value)
        {
            return new ReactiveSource<T>(value).Reactive;
        }

        public static Reactive<T> FromUnityEvent<T>(UnityEvent<T> unityEvent, Func<T> getter = null)
        {
            return unityEvent.ToReactive(getter);
        }

        public static Reactive<T> Lazy<T>(Func<T> get, Func<Reactive<T>> subscribe, Action unsubscribe = null)
        {
            return ReactiveExtensions.Lazy(get, subscribe, unsubscribe);
        }

        public static Reactive<T> Lazy<T>(Func<Reactive<T>> reactive, Action unsubscribe = null)
        {
            return ReactiveExtensions.Lazy(() => reactive().Value, reactive, unsubscribe);
        }

        public static Reactive<Unit> FromEvent(Action<Action> addHandler, Action<Action> removeHandler)
        {
            return ReactiveExtensions.FromEvent(addHandler, removeHandler);
        }

        public static Reactive<T> FromEvent<T>(Action<Action<T>> addHandler, Action<Action<T>> removeHandler, T initial = default)
        {
            return ReactiveExtensions.FromEvent(addHandler, removeHandler, initial);
        }

        public static ReactiveSubscription Bind<T>(IBindableReactive<T> a, IBindableReactive<T> b)
        {
            if (a.IsReadOnly && b.IsReadOnly)
            {
                return new ReactiveSubscription();
            }

            if (a.IsReadOnly)
            {
                return a.Reactive.OnValue(x => b.TrySetValue(x));
            }

            if (b.IsReadOnly)
            {
                return b.Reactive.OnValue(x => a.TrySetValue(x));
            }

            int silenceA = 0;
            int silenceB = 0;
            return a.Reactive.OnValue(x =>
            {
                if (silenceB > 0)
                {
                    return;
                }

                silenceA++;
                try
                {
                    b.TrySetValue(x);
                }
                catch (Exception e)
                {
                    Debug.LogException(e);
                    throw;
                }
                finally
                {
                    silenceA--;
                }
            }) & b.Reactive.OnValue(x =>
            {
                if (silenceA > 0)
                {
                    return;
                }

                silenceB++;
                try
                {
                    a.TrySetValue(x);
                }
                catch (Exception e)
                {
                    Debug.LogException(e);
                    throw;
                }
                finally
                {
                    silenceB--;
                }
            });
        }
    }

    public readonly struct Reactive<T> : IBindableReactive<T>, IUniTaskAsyncEnumerable<T>
    {
        public IReactiveSource<T> Source { get; }

        public Reactive([NotNull] IReactiveSource<T> source)
        {
            this.Source = source;
        }

        private sealed class Handler : IReactiveHandler
        {
            [NotNull]
            private readonly Action<T> _handler;

            [NotNull]
            private readonly IReactiveSource<T> _source;

            public Handler([NotNull] IReactiveSource<T> source, [NotNull] Action<T> handler)
            {
                this._source = source;
                this._handler = handler;
            }

            public void OnValueChanging()
            {
            }

            public void OnValueChanged()
            {
                this._handler(this._source.Value);
            }

            public void OnValueChangeCancelled()
            {
            }
        }

        private sealed class HandlerWithState<TState> : IReactiveHandler
        {
            [NotNull]
            private readonly Action<TState, T> _handler;

            [NotNull]
            private readonly IReactiveSource<T> _source;

            private readonly TState _state;

            public HandlerWithState([NotNull] IReactiveSource<T> source, TState state, [NotNull] Action<TState, T> handler)
            {
                this._source = source;
                this._handler = handler;
                this._state = state;
            }

            public void OnValueChanging()
            {
            }

            public void OnValueChanged()
            {
                this._handler(this._state, this._source.Value);
            }

            public void OnValueChangeCancelled()
            {
            }
        }

        /// <summary>
        ///     Set up an action to react on every new value of this reactive, including the initial one.
        /// </summary>
        public ReactiveSubscription OnValue([NotNull] Action<T> handler)
        {
            ReactiveSubscription subscription = this.Source.OnValueUpdate(new Handler(this.Source, handler));
            handler(this.Source.Value); // Running initial handler after registering is more efficient for e.g. Selector
            return subscription;
        }

        /// <summary>
        ///     Set up an action to react on every new value of this reactive, including the initial one.
        /// </summary>
        public ReactiveSubscription OnValueWithState<TState>(TState state, [NotNull] Action<TState, T> handler)
        {
            ReactiveSubscription subscription = this.Source.OnValueUpdate(new HandlerWithState<TState>(this.Source, state, handler));
            handler(state, this.Source.Value); // Running initial handler after registering is more efficient for e.g. Selector
            return subscription;
        }

        public T Value => this.Source.Value;

        Reactive<T> IBindableReactive<T>.Reactive => this;

        bool IBindableReactive.IsReadOnly => true;

        bool IBindableReactive<T>.TrySetValue(in T value)
        {
            return false;
        }

        public IUniTaskAsyncEnumerator<T> GetAsyncEnumerator(CancellationToken cancellationToken = new())
        {
            return new AsyncReactiveEnumerator<T>(this, cancellationToken);
        }

        IUniTaskAsyncEnumerator<T> IUniTaskAsyncEnumerable<T>.GetAsyncEnumerator(CancellationToken cancellationToken)
        {
            return this.GetAsyncEnumerator(cancellationToken);
        }
    }
}