// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.Debug
{
    public class DebugKillAllEnemiesBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private bool killOnlyOne;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}