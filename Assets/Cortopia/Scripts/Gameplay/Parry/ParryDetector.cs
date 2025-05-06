// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay.Parry
{
    [RequireComponent(typeof(Rigidbody))]
    public class ParryDetector : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> canParry;
        [SerializeField]
        private BoundValue<float> parryCooldownDuration = new(1);
        [SerializeField]
        private BoundValue<float> parryVelocityThreshold = new(3);
        [Space]
        [SerializeField]
        private BoundValue<bool> canBeParried;
        [SerializeField]
        private BoundValue<float> parriedForceApplyVelocity = new(20);
        [SerializeField]
        private BoundValue<float> parriedForceUpAngle = new(20);

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}