// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public class ThrustForce : MonoBehaviour
    {
        public Vector3 localDirection = Vector3.up;
        public float targetSpeed = 5;
        public float damper = 100;
        public float maximumForce = Mathf.Infinity;
        public float rotationDamper = 100;

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

        private void OnValidate()
        {
            this.localDirection = this.localDirection.normalized;
        }
    }
}