// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.AI.Navigation
{
    public class NavMeshAntiTarget : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> avoidTarget;
        [SerializeField]
        private NavMeshAgentType navMeshAgentType;
        [Tooltip("Recalculate the position when the target has moved this distance.")]
        [SerializeField]
        private float targetHasMovedDistanceThreshold = 2;
        [Tooltip("Only recalculate the position when the target is within this distance.")]
        [SerializeField]
        private float closeToTargetThreshold = 6;

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void TryCalculateNewPosition()
        {
            throw new NotImplementedException();
        }
    }
}