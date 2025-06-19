// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using FMODUnity;
using UnityEngine;

namespace Cortopia.Scripts.FX
{
    public class SwooshSfx : GravesBehaviour
    {
        [SerializeField]
        private new Rigidbody rigidbody;
        [Space]
        [SerializeField]
        private BoundValue<float> accelerationPeakDelay;
        [SerializeField]
        private BoundValue<float> accelerationThreshold;
        [SerializeField]
        private BoundValue<float> accelerationReturn;
        [SerializeField]
        private BoundValue<float> accelerationMaxClamp = new(10);
        [SerializeField]
        private BoundValue<float> speedThreshold;
        [Space]
        [SerializeField]
        private float sfxParameterScale = 10;
        [SerializeField]
        private string sfxParameterName;
        [SerializeField]
        private StudioEventEmitter sfxEmitter;

        public Reactive<float> Acceleration => new();

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}