// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(Rigidbody))]
    public class DynamicContactOffset : MonoBehaviour
    {
        [HelpBox(
            "Control the contact offset for all colliders attached to the rigidbody based on the velocity. velocityReferencePoint is the point where the velocity should be checked.")]
        [Space]
        [SerializeField]
        // [CanBeNull]
        private Transform velocityReferencePoint;
        [Space]
        [HelpBox("Map the min/max velocity to the desired min/max contact offset. Contact offset must always be more than 0.")]
        [Space]
        [SerializeField]
        private BoundValue<float> minVelocity;
        [SerializeField]
        private BoundValue<float> maxVelocity;
        [SerializeField]
        private BoundValue<float> minContactOffset;
        [SerializeField]
        private BoundValue<float> maxContactOffset;

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