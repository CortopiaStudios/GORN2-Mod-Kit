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
    public class IgnoreCollisionBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<GameObject> object1;
        [SerializeField]
        private BoundValue<GameObject> object2;
        [SerializeField]
        private bool ignoreTriggers;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}