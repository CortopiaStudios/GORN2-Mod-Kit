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
    [RequireComponent(typeof(ConfigurableJoint))]
    public class PullString : MonoBehaviour
    {
        private const float BaseRetractSpeed = 0.01f;

        [Space]
        [SerializeField]
        private BoundValue<bool> isGrabbed;

        [Tooltip("The point from which to measure how far the PullString has been pulled.")]
        [SerializeField]
        private BoundValue<Transform> referencePoint;

        [Tooltip("The amount of distance from the reference point to keep as a minimum.")]
        [SerializeField]
        private BoundValue<float> minDistance = new(0.1f);

        [SerializeField]
        private BoundValue<float> retractSpeed = new(5f);

        [Tooltip(
            "External components can listen to a Reactive on this script that continually triggers while the PullString is retracting. This variable specifies how many times said event triggers per Unity distance-unit.")]
        [SerializeField]
        private BoundValue<int> ticksPerUnit = new(8);

        public Reactive<float> CurrentSpeed => default;

        public Reactive<bool> IsRetracting => default;

        public Reactive<IntegerCounter> Ticker => default;

        private void Start()
        {
            throw new NotImplementedException();
        }

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