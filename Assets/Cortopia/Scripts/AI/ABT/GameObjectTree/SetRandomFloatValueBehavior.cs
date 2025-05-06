// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    [AddComponentMenu("BehaviorTree/Common/SetRandomFloatValueBehavior")]
    public class SetRandomFloatValueBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private WritableBoundValue<float> value;
        [SerializeField]
        [Tooltip("Inclusive lower boundary")]
        private BoundValue<float> minValue;
        [SerializeField]
        [Tooltip("Inclusive upper boundary")]
        private BoundValue<float> maxValue;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return new BtAction(this.DebugName, () => this.value.TrySetValue(Random.Range(this.minValue.Reactive.Value, this.maxValue.Reactive.Value)));
        }
    }
}