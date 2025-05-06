// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.Common
{
    public class RandomDelayBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<float> minDelay;
        [SerializeField]
        private BoundValue<float> maxDelay;
        [SerializeField]
        private bool unscaledTime;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}