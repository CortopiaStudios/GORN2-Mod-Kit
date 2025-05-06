// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class Bowstring : MonoBehaviour
    {
        [HelpBox(
            "This script outputs a power value between 0-1 based on how far this Transform has been pulled from a reference Transform, along that Transform's Back vector.")]
        [SerializeField]
        private BoundValue<bool> isGrabbed;

        [SerializeField]
        private BoundValue<bool> isGrabbedByLeftHand;

        [SerializeField]
        private BoundValue<bool> alwaysReleaseWithFullPower;

        [Space]
        [Tooltip(
            "A separate Transform from which it's measured how far the Bowstring's Transform has been pulled. This is also used to determine orientation. Distance is measured from the starting point relative to this Transform, so the two don't need to overlap.")]
        [SerializeField]
        private Transform referenceTransform;

        [Tooltip("The distance at which output power goes above zero.")]
        [Min(0f)]
        [SerializeField]
        private float minEffectiveDistance;

        [Tooltip("The distance at which the power is capped to 1.")]
        [Min(0f)]
        [SerializeField]
        private float maxEffectiveDistance;

        [Space]
        [Tooltip("The bow Rigidbody.")]
        // [CanBeNull]
        [SerializeField]
        private Rigidbody bowBody;
        [Tooltip("The Rigidbody that Projectile instances will be jointed to. This can be left null if the associated projectile launcher is launching via prefab.")]
        // [CanBeNull]
        [SerializeField]
        private Rigidbody nockingBody;

        [Tooltip("How much to rotate nockingTransform on the Y-axis when the Bowstring is not pulled at all. This value is inverted when grabbing with the left hand.")]
        [SerializeField]
        private float minNockingRotationY;

        [Tooltip(
            "How much to rotate nockingTransform on the Y-axis when the Bowstring is pulled to its furthest point. This value is inverted when grabbing with the left hand.")]
        [SerializeField]
        private float maxNockingRotationY;

        public Reactive<float> PullBackDistanceNormalized => default;
        public Reactive<float> PullBackSpeed => default;
        public Reactive<float> ReleasedPower => default;
        public Reactive<IntegerCounter> OnPoweredRelease => default;
        public Reactive<IntegerCounter> OnNonPoweredRelease => default;

        public Transform ReferenceTransform => default;

        private void Update()
        {
            throw new NotImplementedException();
        }

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

        public void SyncNockingTransform()
        {
            throw new NotImplementedException();
        }
    }
}