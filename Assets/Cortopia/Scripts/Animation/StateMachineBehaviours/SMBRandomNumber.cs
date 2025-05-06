// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Animation.StateMachineBehaviours
{
    // ReSharper disable once InconsistentNaming
    public class SMBRandomNumber : StateMachineBehaviour
    {
        [SerializeField]
        private string parameterName = "RandomNumber";

        [SerializeField]
        private float minValue;

        [SerializeField]
        private float maxValue = 1f;

        [SerializeField]
        private bool asInteger;

        [SerializeField]
        private bool runOnce;

        [SerializeField]
        private bool changeOnEnter;

        public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            throw new NotImplementedException();
        }

        public override void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            throw new NotImplementedException();
        }
    }
}