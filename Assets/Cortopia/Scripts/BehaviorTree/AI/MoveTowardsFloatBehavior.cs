// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.AI
{
    public class MoveTowardsFloatBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private WritableBoundValue<float> value;
        [SerializeField]
        private BoundValue<float> endValue;
        [SerializeField]
        private Unit changeValueUnit = Unit.Speed;
        [SerializeField]
        private BoundValue<float> changeValue;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }

        private enum Unit
        {
            Speed,
            Time
        }
    }
}