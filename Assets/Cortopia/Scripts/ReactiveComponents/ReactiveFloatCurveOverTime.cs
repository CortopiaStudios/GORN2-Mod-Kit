// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveFloatCurveOverTime : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> startTime;
        [SerializeField]
        private BoundValue<float> easeInTime = new(1);
        [SerializeField]
        private AnimationCurve easeInCurve;
        [SerializeField]
        private BoundValue<float> stayTime = new(1);
        [SerializeField]
        private BoundValue<float> easeOutTime = new(1);
        [SerializeField]
        private AnimationCurve easeOutCurve;
        [SerializeField]
        private BoundValue<float> peakValue = new(0);
        [SerializeField]
        private BoundValue<float> lowValue = new(1);

        public Reactive<float> Output => default;

        private void FixedUpdate()
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