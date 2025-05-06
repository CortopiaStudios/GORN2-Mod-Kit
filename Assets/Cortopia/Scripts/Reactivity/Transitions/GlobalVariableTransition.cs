// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Transitions
{
    public abstract class GlobalVariableTransition<T> : MonoBehaviour where T : IEquatable<T>
    {
        [SerializeField]
        protected BoundValue<bool> doTransition;
        [SerializeField]
        [Space]
        [Tooltip("Enable to always allow transition, regardless of current value")]
        protected bool alwaysTransition;
        [SerializeField]
        protected BoundValue<T> fromValue;
        [SerializeField]
        protected BoundValue<T> toValue;
        [Space]
        [SerializeField]
        protected WritableBoundValue<T>[] targetValues;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = new ReactiveSubscription();
            foreach (var boundValue in this.targetValues)
            {
                this._subscription &= this.doTransition.Reactive.Select(b => b
                        ? boundValue.Reactive.Combine(this.fromValue.Reactive, this.toValue.Reactive)
                            .Select((current, from, to) => this.alwaysTransition || current.Equals(from) ? to : current)
                        : Reactive.Constant(boundValue.Reactive.Value))
                    .Switch()
                    .OnValue(x =>
                    {
                        if (!x.Equals(boundValue.Reactive.Value))
                        {
                            boundValue.SetValue(x);
                        }
                    });
            }
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}