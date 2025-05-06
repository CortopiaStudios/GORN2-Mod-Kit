// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

namespace Cortopia.Scripts.Reactivity
{
    /// <summary>
    ///     Like a ReactiveSource, but also connected to an upstream Reactive. Any values set directly on this will be
    ///     overwritten when the upstream reactive changes.
    ///     Downstream handlers will react on both type of changes.
    /// </summary>
    public class SpeculativeReactive<T> : IWritableBindableReactive<T>
    {
        private readonly SpeculativeReactiveTrigger _reactiveTrigger;

        public SpeculativeReactive(in Reactive<T> reactive)
        {
            this._reactiveTrigger = new SpeculativeReactiveTrigger(reactive.Source);
        }

        public T Value
        {
            get => this._reactiveTrigger.Value;
            set => ((IWritableBindableReactive<T>) this).SetValue(value);
        }

        public Reactive<T> Reactive => new(this._reactiveTrigger);

        void IWritableBindableReactive<T>.SetValue(in T value)
        {
            this._reactiveTrigger.OnValueChanging();
            this._reactiveTrigger.IsSpeculating = true;
            this._reactiveTrigger.SpeculativeValue = value;
            ReactiveTransaction.Register(this._reactiveTrigger);
        }

        bool IBindableReactive.IsReadOnly => false;

        bool IBindableReactive<T>.TrySetValue(in T value)
        {
            this.Value = value;
            return true;
        }

        private sealed class SpeculativeReactiveTrigger : ReactiveBase, IReactiveSource<T>, IReactiveHandler
        {
            private readonly IReactiveSource<T> _reactive;
            private ReactiveSubscription _subscription;

            public SpeculativeReactiveTrigger(in IReactiveSource<T> reactive)
            {
                this._reactive = reactive;
            }

            public T SpeculativeValue { get; set; }
            public bool IsSpeculating { get; set; }

            public new void OnValueChanging()
            {
                if (this.IsSpeculating)
                {
                    this.IsSpeculating = false;
                    this.SpeculativeValue = default(T);
                }

                base.OnValueChanging();
            }

            public T Value => this.IsSpeculating ? this.SpeculativeValue : this._reactive.Value;

            protected override void Subscribe()
            {
                this._subscription = this._reactive.OnValueUpdate(this);
            }

            protected override void UnSubscribe()
            {
                this._subscription.Dispose();
            }
        }
    }
}