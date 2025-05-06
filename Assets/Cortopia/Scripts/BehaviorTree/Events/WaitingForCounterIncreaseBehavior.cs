// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.Events
{
    public class WaitingForCounterIncreaseBehavior : BehaviorTreeBase
    {
        [SerializeField]
        protected BoundValue<IntegerCounter> counter;
        [SerializeField]
        protected bool keepOldCounter = true;

        [UsedImplicitly]
        public Reactive<int> CountChange => new();

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}