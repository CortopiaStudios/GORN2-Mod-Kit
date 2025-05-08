// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Gore.Slicing;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(Rigidbody))]
    public class DamageDetector : GravesBehaviour
    {
        [SerializeField]
        private float damageScale = 1;
        [SerializeField]
        private float damageOnDismemberment = 100;
        [SerializeField]
        private bool killCharacterOnDismemberment;

        [Header("Impacts")]
        [SerializeField]
        private float impactMomentumThreshold;
        [Range(0f, 1f)]
        public float impactAddForceAlpha = 1f;
        [SerializeField]
        private BoundValue<bool> isStunnable;
        [SerializeField]
        private bool takeImpactsFromStaticColliders = true;

        [Header("Stabbing")]
        [SerializeField]
        private bool stunWhenStabbed;

        [Header("Crushing")]
        [SerializeField]
        private float startingCrushForceThreshold = 10000;
        [Tooltip("The lowest the crush force threshold can go. This is ignored for collision with lava.")]
        [SerializeField]
        private float lowestCrushForceThreshold = 3000;
        [SerializeField]
        private Transform crushEffectSpawnPose;
        [SerializeField]
        private AssetReferenceGameObject crushEffect;
        [SerializeField]
        private bool crushWholeBody;

        [Header("Tearing")]
        [SerializeField]
        // [CanBeNull]
        public Transform tearLocalSlicePlane;
        [SerializeField]
        private float jointBreakDistance = 0.35f;
        [SerializeField]
        private float jointBreakDistanceStart = 0.1f;

        [SerializeField]
        private UnityEvent<DamageEvent> onDamage;

        public Reactive<bool> IsStunnable => default;

        public Reactive<float> TearDistance01 => default;

        public Reactive<bool> IsAlive => default;

        public Reactive<bool> IsDead => default;

        public Reactive<Slicable> Slicable => default;

        private void Start()
        {
            throw new NotImplementedException();
        }

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

        public void UpdateSlicableInLimbHierarchy()
        {
            throw new NotImplementedException();
        }
    }
}