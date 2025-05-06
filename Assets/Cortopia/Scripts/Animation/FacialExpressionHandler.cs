// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class FacialExpressionHandler : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive = new(true);
        [SerializeField]
        private BoundValue<Animator> animator;
        [SerializeField]
        private BoundValue<float> normalizedTransitionDuration;

        [Space]
        [Tooltip("The names of all available facial expressions. The names have to match the names of the states within the animator's expression layer!")]
        [SerializeField]
        private string[] expressionNames;
        [SerializeField]
        private BoundValue<int> expressionIndex = new(0);

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }
    }
}