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
    [AddComponentMenu("BehaviorTree/Common/DelayBehavior")]
    public class DelayBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<float> delay;
        [SerializeField]
        private bool unscaledTime;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return new BtWait(this.DebugName, this.unscaledTime, () => this.delay.Reactive.Value);
        }
    }
}