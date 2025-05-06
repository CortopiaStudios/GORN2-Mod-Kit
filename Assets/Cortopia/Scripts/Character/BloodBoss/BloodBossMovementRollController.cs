// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BloodBoss
{
    public class BloodBossMovementRollController : MonoBehaviour
    {
        [SerializeField]
        private Transform arenaCenter;
        [SerializeField]
        private float arenaRadius = 8.0f;
        [Space]
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
        private Transform rootTransform;
        [SerializeField]
        private Transform rotateTransform;
        [SerializeField]
        private Transform forwardTransform;
        [SerializeField]
        private BoundValue<Transform> targetTransform;
        [SerializeField]
        private SphereCollider bodyCollider;
        [Space]
        [SerializeField]
        private BoundValue<float> moveAcceleration = new(1f);
        [SerializeField]
        private float attackSpeedFactor = 2f;

        public Reactive<bool> CollisionTrigger => new();

        public Reactive<float> Radius => new();

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