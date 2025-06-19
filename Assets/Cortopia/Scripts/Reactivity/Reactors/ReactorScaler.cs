// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorScaler : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;
        [SerializeField]
        private bool isLooping;
        [SerializeField]
        private Vector3 startScale;
        [SerializeField]
        private Vector3 endScale;
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }

        private void Update()
        {
        }
    }
}