// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.AI
{
    public class CheckAlignmentBehavior : BehaviorTreeBase
    {
        [Space]
        [HelpBox(
            "This script compares the dot product of the forward direction and the direction from the forward transform to the target transform, to find how well-aligned they are.")]
        [Space]
        [SerializeField]
        private BoundValue<Transform> forward;
        [SerializeField]
        private BoundValue<Transform> target;
        [Tooltip(
            "The dot product to compare against. If forward and the direction to target are the same, the dot product would be 1 - if the are opposite, it would be -1.")]
        [SerializeField]
        private BoundValue<float> compareDot;
        [Space]
        [SerializeField]
        private CompareMethod comparison = CompareMethod.LessThan;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }

        private enum CompareMethod
        {
            LessThan,
            GreaterThan
        }
    }
}