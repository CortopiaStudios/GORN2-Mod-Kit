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
    [AddComponentMenu("BehaviorTree/Group/WhenBehavior")]
    public class WhenBehavior : BehaviorTreeGroupBase
    {
        [SerializeField]
        private BoundValue<bool> when;
        [SerializeField]
        private bool invertWhen;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return this.WithSubTrees(new BtWhen(this.DebugName, this.invertWhen ? this.when.Reactive.Select(x => !x) : this.when));
        }
    }
}