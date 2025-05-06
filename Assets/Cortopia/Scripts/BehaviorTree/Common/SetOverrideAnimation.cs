// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.ReactiveComponents.Animator;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.Common
{
    [AddComponentMenu("BehaviorTree/Common/SetOverrideAnimation")]
    public class SetOverrideAnimation : BehaviorTreeBase
    {
        [SerializeField]
        private WritableBoundValue<AnimationOverride> animationOverride;
        [SerializeField]
        private AnimationOverride newAnimationOverride;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}