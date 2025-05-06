// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gore
{
    public class BluntDamageModifier : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive = new(true);
        [SerializeField]
        private PoseTracker poseTracker;
        [Space]
        [SerializeField]
        private BoundValue<float> forceThreshold = new(0.1f);
        [SerializeField]
        [Tooltip("The required momentum (velocity * mass) is needed to trigger impact damage.")]
        private BoundValue<float> damageMomentumThreshold = new(150);
        [Tooltip("Scale the impact damage inflicted.")]
        [SerializeField]
        private BoundValue<float> damageScale = new(1.5f);
        [Tooltip("The cooldown duration in seconds to scale the impact damage.")]
        [SerializeField]
        private BoundValue<float> cooldownDuration = new(1f);
        [SerializeField]
        [Tooltip("Rotate the direction of the added force towards upwards with this number of degrees to make the victim fly higher.")]
        private BoundValue<float> forceDirectionUpwardDegrees = new(10f);
        [Space]
        [SerializeField]
        private ForceMode mode = ForceMode.Impulse;
        [SerializeField]
        private ForceAddMode forceAddMode;
        [Header(nameof(ForceAddMode) + "." + nameof(ForceAddMode.AddConstantForce))]
        [Tooltip("The force applied to all limbs when doing damage.")]
        [SerializeField]
        private BoundValue<float> addConstantForce;

        [Header(nameof(ForceAddMode) + "." + nameof(ForceAddMode.MultiplyForce))]
        [SerializeField]
        private BoundValue<float> multiplyForceAmount = new(1.1f);
        [SerializeField]
        private BoundValue<float> multiplyForceCeiling = new(400f);

        [Header(nameof(ForceAddMode) + "." + nameof(ForceAddMode.AddVelocityBasedForce))]
        [Tooltip("The maximum force applied to all limbs when doing damage. This is scaled down internally depending on the velocity of this object.")]
        [SerializeField]
        private BoundValue<float> maxForce;
        [Tooltip("The amount of velocity needed to hit with maximum force.")]
        [SerializeField]
        private BoundValue<float> maxForceVelocity;

        [SerializeField]
        [Tooltip("When the player scale is smaller than scale 1 the total damage made by the player can be scaled up by 1 / player scale.")]
        private bool scaleDamageWithSmallPlayerScale;
        [SerializeField]
        private BoundValue<bool> useManuallyCalculatedImpulse;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        private enum ForceAddMode
        {
            AddConstantForce,
            MultiplyForce,
            AddVelocityBasedForce
        }
    }
}