// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Interaction
{
    public class GrabbableRoot : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Except for this condition, objects that are grabbed, attached to a GrabbableSlot or a ProjectileLauncher cannot be force grabbed")]
        private BoundValue<bool> canForceGrab = new(true);

        public Reactive<bool> Grabbed => default;

        public Reactive<bool> GrabbedByPlayer => default;

        public bool CanForceGrab => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void InitializeRoot()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        ///     Finds all child Grabbables and forcibly releases them from their grabbers.
        /// </summary>
        public void ForceRelease()
        {
            throw new NotImplementedException();
        }
    }
}