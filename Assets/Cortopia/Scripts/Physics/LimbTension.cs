// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(DamageDetector))]
    public class LimbTension : GravesBehaviour
    {
        [SerializeField]
        private bool scaleTensionWithCharacterScale = true;
        [SerializeField]
        private BoundValue<float> tensionMultiplier = new(1);
        [SerializeField]
        private float impactRelaxDuration = 1;
        [SerializeField]
        private float parriedBlockedRelaxDuration = 1;
        [SerializeField]
        private float recoveryDuration = 1;
        [SerializeField]
        private float recoveryDelay;
        [SerializeField]
        private float recoveryPower = 1;
        [HelpBox("The limb tension when the character is stunned. Should be in the range of 0 to 1.")]
        [SerializeField]
        private float stunnedTension = 1;
        [SerializeField]
        private BoundValue<JointDrive> minSlerpDrive =
            new(new JointDrive {positionSpring = 1000, positionDamper = 100, maximumForce = float.PositiveInfinity, useAcceleration = true});
        [SerializeField]
        private BoundValue<JointDrive> maxSlerpDrive =
            new(new JointDrive {positionSpring = 1000, positionDamper = 100, maximumForce = float.PositiveInfinity, useAcceleration = true});

        public Reactive<float> Tension => default;

        public Reactive<bool> IsTense => default;

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