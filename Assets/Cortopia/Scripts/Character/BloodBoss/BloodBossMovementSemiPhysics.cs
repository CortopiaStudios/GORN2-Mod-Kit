// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Character.BloodBoss
{
    public class BloodBossMovementSemiPhysics : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> bossIsAttacking;
        [SerializeField]
        private BoundValue<bool> bossIsDamaged;
        [SerializeField]
        private BoundValue<bool> bossIsRetreating;
        [SerializeField]
        private BoundValue<bool> bossIsBouncing;
        [SerializeField]
        [Tooltip("Target for the maximum speed of the boss, the actual move speed is interpolated toward this value")]
        private BoundValue<float> maxMoveSpeed;
        [SerializeField]
        [Tooltip("Target speed of the boss, the actual move speed is interpolated toward this value")]
        private BoundValue<float> moveSpeed;
        [SerializeField]
        [Tooltip("Target turn speed of the boss, the actual turn is updated towards the target transform when this value is above zero")]
        private BoundValue<float> turnSpeed;
        [SerializeField]
        private BoundValue<float> moveAcceleration = new(1f);
        [SerializeField]
        private BoundValue<float> attackSpeedFactor = new(2f);
        [SerializeField]
        private BoundValue<float> targetVerticalSpeed = new(4f);
        [SerializeField]
        private BoundValue<float> targetBounceHeight = new(4f);
        [SerializeField]
        [Tooltip("The minimum speed needed to crush colliding limbs")]
        private BoundValue<float> limbCrushSpeedThreshold = new(1f);
        [Space]
        [SerializeField]
        private Transform rootTransform;
        [SerializeField]
        private Transform rotateTransform;
        [SerializeField]
        private Transform forwardTransform;
        [SerializeField]
        private BoundValue<Transform> targetTransform;
        [SerializeField]
        private Transform scaleTransform;
        [SerializeField]
        private SphereCollider radiusCollider;
        [Space]
        [SerializeField]
        private float maxWaitForEndBounceTime = 1.0f;
        [SerializeField]
        private float maxDistanceOutsideNavMesh = 0.2f;
        [SerializeField]
        private string wallTag;
        [SerializeField]
        private bool drawDebugLines;
        public UnityEvent onBounceHitGround = new();
        public UnityEvent onBounceStart = new();

        public Reactive<float> Radius => new();

        public Reactive<IntegerCounter> WallCollision => new();

        public float RootGroundHeight { get; set; }

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

        public void StopIntroStartRolling()
        {
            throw new NotImplementedException();
        }
    }
}