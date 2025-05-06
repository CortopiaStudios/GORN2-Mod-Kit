// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Serialization;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    [AddComponentMenu("BehaviorTree/Common/WaitForTrueBehavior")]
    public class WaitForTrueBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<bool> condition;
        [FormerlySerializedAs("invertCondition")]
        [SerializeField]
        private bool waitForFalseInstead;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return new BtAction(this.DebugName, c => this.condition.Reactive.ToTaskWhen(x => x ^ this.waitForFalseInstead, c.AsCancellationToken));
        }
    }
}