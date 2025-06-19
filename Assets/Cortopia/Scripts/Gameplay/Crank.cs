// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class Crank : MonoBehaviour
    {
        [Tooltip(
            "The script can function under two different modes - TickWhileCranking will trigger a Reactive event continually as you crank, TickAfterWindup will make the crank reverse when you let go and trigger the Reactive event during this process.")]
        [SerializeField]
        private Mode mode;

        [Space]
        [SerializeField]
        private BoundValue<bool> isGrabbed;

        [Tooltip(
            "This Transform is used both as the point around which to measure revolutions, as well as for visually representing the crank. Cranking is always around this object's X-axis.")]
        [SerializeField]
        private BoundValue<Transform> rotateTransform;

        [SerializeField]
        private BoundValue<float> reverseSpeed = new(1000f);

        [Tooltip(
            "External components can listen to a Reactive on this script that continually triggers while the crank is moving (depending on the selected mode). This variable specifies how many times said event triggers per 360 degrees.")]
        [SerializeField]
        private BoundValue<int> ticksPerFullRotation = new(8);

        [SerializeField]
        [Tooltip("A small allowance for cranking the wrong direction may make it easier to pull the crank")]
        private float wrongDirectionAngleThreshold = 5.0f;

        [SerializeField]
        private bool isCounterClockWise;

        [Header("Editor")]
        [SerializeField]
        private bool debugDraw;

        public Reactive<float> CurrentSpeed => new();
        public Reactive<bool> IsRotating => new();
        public Reactive<IntegerCounter> Ticker => new();
        public Reactive<IntegerCounter> OnCrankInWrongDirection => new();

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

        private enum Mode
        {
            TickWhileCranking,
            TickAfterWindup
        }
    }
}