// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Interaction;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    [RequireComponent(typeof(SphereCollider))]
    public class ProjectileNockingTrigger : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;

        [SerializeField]
        private BoundValue<IntegerCounter> clearNockedProjectile;

        [Space]
        [SerializeField]
        private string acceptedTag;

        [Space]
        [Tooltip("A triggering projectile is force-released from its hand, this Grabbable will then be force-grabbed instead - like the bowstring, for example!")]
        [SerializeField]
        private BoundValue<Grabbable> replacementGrabbable;

        public Reactive<GameObject> NockedProjectileObject => default;

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