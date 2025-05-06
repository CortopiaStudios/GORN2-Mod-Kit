// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Gameplay;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    public class ExplosiveForce : MonoBehaviour
    {
        [SerializeField]
        // [CanBeNull]
        private DamageContext damageContext;

        [SerializeField]
        private bool activateOnEnable;
        [SerializeField]
        private LayerMask layerMask;
        [SerializeField]
        private float radius;
        [SerializeField]
        private float radiusTearing;
        [SerializeField]
        private float radiusCrushing;
        [SerializeField]
        [Tooltip(
            "Curve for variation of chance of tearing within the tearing radius, where 0 is the chance at origin of the explosion and 1 is the chance at the tearing radius distance")]
        private AnimationCurve chanceTearing;
        [SerializeField]
        [Tooltip(
            "Curve for variation of chance of crushing within the crushing radius, where 0 is the chance at origin of the explosion and 1 is the chance at the crushing radius distance")]
        private AnimationCurve chanceCrushing;
        [SerializeField]
        private float force = 10.0f;
        [SerializeField]
        private float upwardsMultiplier = 10.0f;
        [SerializeField]
        private UnityEvent<Rigidbody> onTrigger;
        [SerializeField]
        private UnityEvent<Life> onHitLife;
        [Tooltip("The GameObject containing the Life component that was hit by the explosion.")]
        [SerializeField]
        private UnityEvent<GameObject> hitLifeObject;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void Activate()
        {
            throw new NotImplementedException();
        }
    }
}