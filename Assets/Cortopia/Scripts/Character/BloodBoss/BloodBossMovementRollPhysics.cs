// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Character.BloodBoss
{
    [RequireComponent(typeof(Rigidbody))]
    public class BloodBossMovementRollPhysics : MonoBehaviour
    {
        public enum BloodBossState
        {
            Rolling,
            Attacking,
            Retreating,
            Damaged
        }

        [SerializeField]
        private BoundValue<bool> bossIsAttacking;
        [SerializeField]
        private BoundValue<bool> bossIsDamaged;
        [SerializeField]
        private BoundValue<bool> bossIsDeflated;
        [SerializeField]
        private BoundValue<bool> bossIsRetreating;
        [SerializeField]
        private BoundValue<float> targetMaxMoveSpeed;
        [SerializeField]
        private BoundValue<float> targetMoveSpeed;
        [SerializeField]
        private BoundValue<float> targetTurnSpeed;
        [Space]
        [SerializeField]
        private Transform forwardTransform;
        [SerializeField]
        private BoundValue<Transform> targetTransform;
        [Space]
        [SerializeField]
        private BoundValue<float> moveAcceleration = new(1f);
        [SerializeField]
        private float moveForce = 500.0f;
        [SerializeField]
        private float retreatForce = 700.0f;
        [SerializeField]
        private float attackSpeedFactor = 2f;
        [Space]
        [SerializeField]
        private LayerMask layerMaskWalls;

        public Reactive<bool> WallCollisionTrigger => new();

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