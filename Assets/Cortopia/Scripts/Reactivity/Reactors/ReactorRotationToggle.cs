// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorRotationToggle : MonoBehaviour
    {
        [Header("Reactive")]
        [SerializeField]
        private BoundValue<bool> toggleValue;
        
        [Header("Rotation Settings")]
        [SerializeField]
        private Vector3 falseRotation;
        [SerializeField]
        private Vector3 trueRotation;
        
        [Header("Animation Settings")]
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;
        [SerializeField]
        private float delayTime;

        [UsedImplicitly]
        public Reactive<bool> IsTogglingTrue => new();

        [UsedImplicitly]
        public Reactive<bool> IsTogglingFalse => new();

        private void Update()
        {
        }

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}