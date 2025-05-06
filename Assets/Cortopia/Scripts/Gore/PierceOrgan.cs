// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Gore
{
    public class PierceOrgan : MonoBehaviour
    {
        [SerializeField]
        private AssetReferenceGameObject bloodEffect;

        [SerializeField]
        private BoundValue<bool> canPierce = new(true);
        [SerializeField]
        private WritableBoundValue<IntegerCounter> onPierce;
        [SerializeField]
        private Transform organRoot;
        [SerializeField]
        private Vector3 forward = Vector3.forward;
        [Range(0.0f, 180.0f)]
        [SerializeField]
        private float maxPierceAngle = 45.0f;
        [SerializeField]
        private float minPiercingDistance;
        [SerializeField]
        private float pullBackCheckDistance = 0.03f;
        [SerializeField]
        private float jointBreakForce = 1000.0f;
        [SerializeField]
        [Tooltip("Delay before break force is applied after an organ is pierced and is attached to a piercing object")]
        private float jointBreakDelay = 5.0f;
        [Tooltip("The amount of damage to output via a DamageEvent when pierced.")]
        [SerializeField]
        private float damage;

        public Reactive<bool> IsAttached => default;

        public Reactive<bool> IsNotAttached => default;

        public Reactive<DamageEvent> DamageEvent => default;

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