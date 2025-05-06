// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveLayerComparer : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> active;
        [SerializeField]
        private BoundValue<LayerMask> requiredLayer;

        [UsedImplicitly]
        public Reactive<bool> ConditionMet => this.active.Reactive.Combine(this.requiredLayer.Reactive).Select(this.Selector);

        private bool Selector(GameObject arg1, LayerMask arg2)
        {
            return arg1 ? (arg2.value & (1 << arg1.layer)) != 0 : false;
        }
    }
}