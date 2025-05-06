// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Reactivity
{
    public class CounterEvent : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<IntegerCounter> counter;

        [SerializeField]
        private UnityEvent counterIncreased;

        private uint? _previous;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._previous = null;
            this._subscription = this.counter.Reactive.OnValue(this.NewValue);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void NewValue(IntegerCounter value)
        {
            bool trigger = this._previous.HasValue && this._previous.Value != value.CounterValue;
            this._previous = value.CounterValue;
            if (trigger)
            {
                this.counterIncreased.Invoke();
            }
        }
    }

    public class CounterEvent<T> : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<(IntegerCounter, T)> counter;

        [SerializeField]
        private UnityEvent<T> counterIncreased;

        private uint? _previous;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._previous = null;
            this._subscription = this.counter.Reactive.OnValue(this.NewValue);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void NewValue((IntegerCounter counter, T value) tuple)
        {
            bool trigger = this._previous.HasValue && this._previous.Value != tuple.counter.CounterValue;
            this._previous = tuple.counter.CounterValue;
            if (trigger)
            {
                this.counterIncreased.Invoke(tuple.value);
            }
        }
    }
}