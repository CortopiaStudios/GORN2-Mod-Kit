// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(Rigidbody))]
    public class HandPhysicsMovement : GravesBehaviour
    {
        [SerializeField]
        private Transform target;
        [SerializeField]
        private BoundValue<float> resetDistance;
        [SerializeField]
        private UnityEvent onReset;

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