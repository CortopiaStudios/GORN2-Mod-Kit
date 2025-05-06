// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveImpact : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive = new(true);
        [SerializeField]
        private LayerMask collisionMask;
        [SerializeField]
        private List<Collider> ignoreColliders;
        [SerializeField]
        private BoundValue<float> impactThreshold;
        [SerializeField]
        private BoundValue<float> impactCeiling = new(Mathf.Infinity);
        [SerializeField]
        private BoundValue<float> impactCooldownDuration = new(0);

        public Reactive<IntegerCounter> ImpactCounter => default;
        public Reactive<float> CombinedImpact => default;
    }
}