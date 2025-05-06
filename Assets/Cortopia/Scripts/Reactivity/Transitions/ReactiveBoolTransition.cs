// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Transitions
{
    public class ReactiveBoolTransition : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> doTransition;
        [SerializeField]
        private bool startValue;
        [SerializeField]
        private BoundValue<bool> fromValue;
        [SerializeField]
        private BoundValue<bool> toValue = new(true);

        private readonly ReactiveSource<bool> _output = new(false);
        private ReactiveSubscription _subscription;

        [UsedImplicitly]
        public Reactive<bool> Output => this._output.Reactive;

        private void Awake()
        {
            this._output.Value = this.startValue;
        }

        private void OnEnable()
        {
            this._subscription &= this.doTransition.Reactive.OnValue(b =>
            {
                if (b && this._output.Value == this.fromValue.Reactive.Value)
                {
                    this._output.Value = this.toValue.Reactive.Value;
                }
            });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}