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
    public class FollowWithDelay : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> target;

        [SerializeField]
        private BoundValue<float> positionLerpSpeed = new(5f);

        [SerializeField]
        private BoundValue<float> rotationLerpSpeed = new(5f);

        [SerializeField]
        private BoundValue<bool> unscaledTime = new(true);

        [SerializeField]
        private BoundValue<bool> startAtTargetOnEnable;

        private void Update()
        {
            throw new NotImplementedException();
        }

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