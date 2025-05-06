// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity.Singletons.Types;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Transitions
{
    public class GlobalGameObjectTransition : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> doTransition;
        [SerializeField]
        private GameObject fromValue;
        [SerializeField]
        private GameObject toValue;
        [SerializeField]
        private GameObjectGlobalVariable[] variables;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription &= this.doTransition.Reactive.DistinctUntilChanged()
                .OnValue(b =>
                {
                    if (b)
                    {
                        this.TrySetVariables(this.toValue);
                    }
                });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void TrySetVariables(GameObject value)
        {
            foreach (GameObjectGlobalVariable variable in this.variables)
            {
                if (variable.Variable.Value == this.fromValue)
                {
                    variable.Variable.Value = value;
                }
            }
        }
    }
}