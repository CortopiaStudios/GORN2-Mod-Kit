// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(Limb))]
    public class LimbHealth : MonoBehaviour
    {
        [SerializeField]
        private float maxHealth = 100;
        [SerializeField]
        private UnityEvent onZeroHealth;

        public Reactive<float> CurrentHealth => default;

        public Reactive<float> CurrentHealth01 => default;

        public Reactive<float> CurrentHealth01Inversed => default;

        public Reactive<bool> HasHealth => default;

        public Reactive<bool> HasZeroHealth => default;

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