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
    public class CrushEventsZone : MonoBehaviour
    {
        [SerializeField]
        private UnityEvent onLimbCrush;
        [SerializeField]
        private UnityEvent onWholeCrush;

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