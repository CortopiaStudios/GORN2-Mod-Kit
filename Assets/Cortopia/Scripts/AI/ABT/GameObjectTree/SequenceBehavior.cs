// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.ABT.Nodes;
using UnityEngine;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    [AddComponentMenu("BehaviorTree/Group/SequenceBehavior")]
    public class SequenceBehavior : BehaviorTreeGroupBase
    {
        [SerializeField]
        private BtGroup.Mode mode = BtGroup.Mode.EvaluateSubTreesOnce;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return this.WithSubTrees(new BtSequence(this.DebugName, this.mode));
        }
    }
}