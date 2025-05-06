// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    [RequireComponent(typeof(Animator))]
    public class LayerWeightAnimationListener : MonoBehaviour
    {
        [HelpBox("To set the 'Expression' layer weight, call 'SetExpressionLayerWeight' in an animation event, along with the requested weight.")]
        [Tooltip("The layer name to use when an animation tries to set the 'Expression' layer weight.")]
        [SerializeField]
        private BoundValue<string> expressionLayerName;
        [SerializeField]
        private float transitionTime = 0.5f;

        public void SetExpressionLayerWeight(float weight)
        {
            throw new NotImplementedException();
        }
    }
}