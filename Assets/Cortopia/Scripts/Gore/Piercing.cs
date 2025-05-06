// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Gameplay;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gore
{
    [RequireComponent(typeof(CapsuleCollider))]
    public class Piercing : WeaponTrait
    {
        [SerializeField]
        private BoundValue<float> damage = new(10);
        [SerializeField]
        private float maxPierceDistance = 0.5f;
        // [CanBeNull]
        [SerializeField]
        private DamageContext damageContext;
        [Space]
        [SerializeField]
        private BoundValue<float> stabAngleThreshold = new(40);
        [SerializeField]
        private BoundValue<float> stabForceThreshold = new(0.1f);
        [Space]
        [SerializeField]
        private BoundValue<float> slideDamper = new(100_000);
        [Space]
        [SerializeField]
        private BoundValue<float> lockVelocityThreshold = new(0.05f);
        [SerializeField]
        private BoundValue<float> lockJointBreakForce = new(100);
        [Space]
        [SerializeField]
        private BoundValue<float> detachCooldownDuration = new(-1.0f);
        [Space]
        [SerializeField]
        private float crushTimer = Mathf.Infinity;
        [SerializeField]
        private float crushDistance = Mathf.Infinity;
        [SerializeField]
        private bool crushOnExit;
        [SerializeField]
        private bool canCrushWholeBodies;
        [Space]
        [SerializeField]
        [Tooltip("Should the piercing also trigger impact damage? Useful on the morning star for example.")]
        private bool doImpactDamage;

        public Reactive<bool> IsStabbing => default;

        public Reactive<float> Damage => default;

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}