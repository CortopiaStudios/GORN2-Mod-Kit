// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Gameplay;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class CharacterHealth : MonoBehaviour
    {
        [SerializeField]
        private Life life;
        [Space]
        [SerializeField]
        private BoundValue<float> maxHealth = new(100);

        public Reactive<float> CurrentHealth => new();
        public Reactive<float> CurrentHealth01 => new();
        public Reactive<float> MaxHealth => new();

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