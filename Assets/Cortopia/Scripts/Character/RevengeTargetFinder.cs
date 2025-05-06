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
    public class RevengeTargetFinder : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<DamageEvent> onDamage;
        [SerializeField]
        private BoundValue<Transform> physicalRoot;

        public Reactive<Transform> RevengeTarget => new();
        public Reactive<IntegerCounter> OnFoundRevengeTarget => new();

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