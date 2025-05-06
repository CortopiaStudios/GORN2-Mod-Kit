// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity.Singletons.Types;
using UnityEngine;
using UnityEngine.Assertions;

namespace Cortopia.Scripts.Reactivity.Transitions
{
    public class ReactiveStateTransition : MonoBehaviour
    {
        private const int InvalidIndex = -1;

        [SerializeField]
        private BoundValue<bool> doTransition;
        [SerializeField]
        private string fromState;
        [SerializeField]
        private string toState;
        [SerializeField]
        private StateGlobalVariable stateVariable;

        private int _fromValue;
        private ReactiveSubscription _subscription;
        private int _toValue;

        private void Awake()
        {
            this._fromValue = this.stateVariable.States.IndexOf(this.fromState);
            Assert.AreNotEqual(this._fromValue, InvalidIndex);
            this._toValue = this.stateVariable.States.IndexOf(this.toState);
            Assert.AreNotEqual(this._toValue, InvalidIndex);
        }

        private void OnEnable()
        {
            this._subscription = this.doTransition.Reactive.DistinctUntilChanged()
                .OnValue(transition =>
                {
                    if (transition && this.stateVariable.Variable.Value == this._fromValue)
                    {
                        this.stateVariable.Variable.Value = this._toValue;
                    }
                });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnValidate()
        {
            if (this.stateVariable && (this.stateVariable.States.IndexOf(this.fromState) < 0 || this.stateVariable.States.IndexOf(this.toState) < 0))
            {
                Debug.LogError("Either from or to state is invalid on StateTransition", this);
            }
        }
    }
}