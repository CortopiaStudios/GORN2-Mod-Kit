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
    public class Sharpness : WeaponTrait
    {
        // [CanBeNull]
        [SerializeField]
        private DamageContext damageContext;

        [Space]
        [SerializeField]
        [Tooltip("The maximum radius the intersected vertices of a slicable mesh to actually trigger a slice.")]
        private BoundValue<float> maxSliceRadius = new(0.3f);

        [Space]
        [SerializeField]
        private BoundValue<float> slashAngleThreshold = new(60);
        [SerializeField]
        private BoundValue<float> slashSpeedThreshold = new(5);
        [SerializeField]
        private float sliceSpeedThreshold = 10;

        [Space]
        [SerializeField]
        private float slashDamage = 20;

        [Space]
        [SerializeField]
        [Tooltip("If you want sharp edges that are round you should add the other related sharpness components here to make sure the slash and slicing works correctly.")]
        private Sharpness[] connectedSharpnesses;

        [SerializeField]
        [Tooltip("The joint damper amount when slashing.")]
        private float damper = 1000;
        [SerializeField]
        private float slashDuration = 0.1f;

        public Reactive<float> MaxSliceRadius => default;

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        private void OnCollisionEnter(Collision collision)
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}