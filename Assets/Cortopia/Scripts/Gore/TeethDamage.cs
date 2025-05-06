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
    public class TeethDamage : MonoBehaviour
    {
        [SerializeField]
        private float damageThreshold;
        [SerializeField]
        [Range(0f, 1f)]
        private float probability;
        [SerializeField]
        private ReactiveSource<float> damage;

        public Reactive<float> Damage => default;

        public void OnDamage(DamageEvent e)
        {
            throw new NotImplementedException();
        }
    }
}