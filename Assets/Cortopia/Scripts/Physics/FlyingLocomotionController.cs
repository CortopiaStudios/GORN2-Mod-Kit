// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(ConfigurableJoint))]
    public class FlyingLocomotionController : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Vector3> forwardDir = new(Vector3.forward);
        [SerializeField]
        private BoundValue<Transform> lookAtTarget = new(null);

        [SerializeField]
        private BoundValue<Vector3> localVelocity = new(Vector3.zero);

        [SerializeField]
        private BoundValue<Vector3> worldVelocity = new(Vector3.zero);

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}