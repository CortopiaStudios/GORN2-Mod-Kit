// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Serialization;

namespace Cortopia.Scripts.Character.GutsBoss
{
    public class AimProjectile : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<IntegerCounter> aimTrigger;
        [SerializeField]
        private BoundValue<GameObject> projectileObject;
        [SerializeField]
        private BoundValue<Transform> target;
        [SerializeField]
        [Tooltip("Offset above the target transform position witch aiming is made towards")]
        private BoundValue<float> targetUpwardOffset;
        [FormerlySerializedAs("adjustAngle")]
        [SerializeField]
        [Tooltip("If true, this transform is rotated on world y-axis so that the local z-axis is facing target")]
        private BoundValue<bool> rotateWorldYAxis;
        [SerializeField]
        [Tooltip("If true, this transform is rotated so that the local z-axis is facing target")]
        private BoundValue<bool> rotateTowardsTarget;
        [SerializeField]
        [Tooltip(
            "If RotateTowardsTarget is set to true, this will set an upwards offset angle to the forward direction, which may be needed to solve the trajectory function so that the projectile reaches the target position")]
        private BoundValue<float> upwardsAngleOffset;

        public Reactive<IntegerCounter> ShootTrigger => new();

        public Reactive<float> Force => new();

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