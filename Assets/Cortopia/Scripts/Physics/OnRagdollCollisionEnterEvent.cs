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
    public class OnRagdollCollisionEnterEvent : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> impulseThreshold;
        [SerializeField]
        private BoundValue<float> cooldownDuration;
        [SerializeField]
        private Collider[] ignoreColliders;
        [Space]
        [SerializeField]
        private UnityEvent<Collision> collisionEnter = new();

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