// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    [RequireComponent(typeof(Rigidbody))]
    public class ArrowFletching : MonoBehaviour
    {
        [SerializeField]
        private Vector3 forward;
        [SerializeField]
        private Vector3 forceOffset;
        [SerializeField]
        private float forceFactor;
        [SerializeField]
        private float minimumVelocity;

        [Header("Editor (only works in Play Mode!)")]
        [SerializeField]
        private bool debugVisualization;

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}