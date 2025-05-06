// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class RootLimb : GravesBehaviour
    {
        [SerializeField]
        [Tooltip("How fast the stamina should recover.")]
        private float staminaRecoverySpeed = 0.5f;
        [SerializeField]
        [Tooltip("How long the stamina should hold its current value before regenerating when damaged.")]
        private float staminaHitStayDuration = 2f;
        [SerializeField]
        [Tooltip("Stamina * Damage")]
        private float staminaDrainPerDamage = 0.1f;
        [SerializeField]
        [Tooltip("How much stamina should be drain when being parried.")]
        private float staminaDrainOnParried = 0.3f;
        [SerializeField]
        [Tooltip("How much stamina should be drain when being blocked.")]
        private float staminaDrainOnBlocked = 0.1f;
        [SerializeField]
        [Tooltip("The maximum stamina value.")]
        private float staminaMax = 1;
        [Space]
        [SerializeField]
        [Tooltip("The knocked out duration in seconds.")]
        private float knockedOutDuration = 1;
        [SerializeField]
        [Tooltip("The initial stamina value when recovering from being knocked.")]
        private float knockedOutRecoverStartStability = 0.1f;
        [SerializeField]
        [Tooltip("Extra force applied when getting knocked out.")]
        private float knockOutAddForce = 15;
        [SerializeField]
        [Tooltip("The amount of degrees the added knock out force should be rotated upwards to send them flying more.")]
        private float knockOutAddForceUpwardDegrees = 20;
        [SerializeField]
        [Tooltip("Much how impact momentum is needed to make the character get stunned when hit on a limb with IsStunnable enabled.")]
        private float stunImpactDamageThreshold = 22.5f;
        [SerializeField]
        [Tooltip("Much how impact momentum is needed from a punch by the player to make the character get stunned when hit on a limb with IsStunnable enabled.")]
        private float playerPunchStunImpactDamageThreshold = 18f;
        [SerializeField]
        [Tooltip("The stunned duration in seconds.")]
        private float stunnedDuration = 3;
        [SerializeField]
        [Tooltip("The amount of stamina when being stunned.")]
        private float stunnedStamina = 0.1f;
        [Space]
        [SerializeField]
        [Tooltip("For how long in seconds the characters hip balance/stability should remain at 0 before regenerating.")]
        private float unbalanceHitStayDuration = 0.1f;
        [SerializeField]
        [Tooltip("For how long it takes to regenerate the unbalance value from 0 to 1.")]
        private float unbalanceHitRecoveryDuration = 1f;
        [Space]
        [SerializeField]
        private BoundValue<bool> isGrounded = new(true);
        [SerializeField]
        private float groundedRecoveryDuration = 2;
        [SerializeField]
        [Tooltip("Tension modifier for when character is not grounded")]
        private float ungroundedTension;
        [Space]
        [SerializeField]
        private BoundValue<bool> isStanding = new(false);
        [Space]
        [SerializeField]
        [Tooltip("How long the stamina should hold its current value before regenerating when parried.")]
        private float staminaParriedStayDuration = 2f;

        public Reactive<bool> IsStanding => new();
        public Reactive<float> Stability => new();
        public Reactive<float> Balance => new();
        public Reactive<string> CurrentStateAsString => new();
        public Reactive<bool> IsConscious => new();
        public Reactive<bool> IsKnockedOut => new();
        public Reactive<bool> IsStunned => new();
        public Reactive<float> GroundedTension => new();

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
    }
}