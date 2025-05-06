// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    [RequireComponent(typeof(Rigidbody))]
    [DisallowMultipleComponent]
    public class ReactiveRigidbody : GravesBehaviour
    {
        public override int ExecutionOrder => 100;

        public Reactive<Vector3> Velocity => default;

        public Reactive<Vector3> LocalVelocity => default;

        public Reactive<Vector3> Acceleration => default;

        public Reactive<float> AccelerationSquareMagnitude => default;

        public Reactive<float> VelocitySquareMagnitude => default;

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}