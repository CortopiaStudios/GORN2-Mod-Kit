// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public class LimbDamage : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Max damage per impact")]
        private BoundValue<float> maxDamage;
        [SerializeField]
        [Tooltip("The minimum time in between new impacts to be registered in the combined damage")]
        private BoundValue<float> coolDownTime;

        public Reactive<float> Damage => default;

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

        public void OnDamage(DamageEvent damageInfo)
        {
            throw new NotImplementedException();
        }
    }
}