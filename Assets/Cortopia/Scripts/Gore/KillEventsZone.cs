// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Gore
{
    [RequireComponent(typeof(Collider))]
    public class KillEventsZone : MonoBehaviour
    {
        [SerializeField]
        private UnityEvent onCrushKill;
        [SerializeField]
        private UnityEvent onFireKill;
        [SerializeField]
        private UnityEvent onImpactKill;
        [SerializeField]
        private UnityEvent onSlashKill;
        [SerializeField]
        private UnityEvent onSliceKill;
        [SerializeField]
        private UnityEvent onStabKill;
        [SerializeField]
        private UnityEvent onTearKill;

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