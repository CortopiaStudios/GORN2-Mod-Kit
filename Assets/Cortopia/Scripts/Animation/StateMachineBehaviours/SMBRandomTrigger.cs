// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Animation.StateMachineBehaviours
{
    public sealed class SmbRandomTrigger : StateMachineBehaviour
    {
        [SerializeField]
        private string triggerParameterName = string.Empty;
        [Header("Variation Chance")]
        [SerializeField]
        private float variationChance;
        [Header("Loop Controls")]
        [SerializeField]
        private int minLoops;
        [SerializeField]
        private int maxLoops;

        public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
        {
            throw new NotImplementedException();
        }

        // If the current loop is more than the max loop it will force an idle variation
        public override void OnStateUpdate(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
        {
            throw new NotImplementedException();
        }
    }
}