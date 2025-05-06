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
    [AddComponentMenu("BehaviorTree/Common/ScopeBehaviour")]
    public class ScopeBehavior : BehaviorTreeGroupBase
    {
        private readonly ReactiveSource<bool> _inScope = new(false);
        public Reactive<bool> InScope => this._inScope.Reactive;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return this.WithSubTrees(new BtScope(this.DebugName, this._inScope));
        }
    }
}