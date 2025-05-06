// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.PointOfInterests
{
    public class PointOfInterest : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> radius;

        [SerializeField]
        private BoundValue<int> priority;

        [Tooltip("How many seconds should a listener continue showing interest in the POI, even after exiting its radius? Useful for fast-moving objects.")]
        [SerializeField]
        private BoundValue<float> outsideRadiusLifetime;

        [SerializeField]
        private BoundValue<int> facialExpressionIndex;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        private void OnDrawGizmosSelected()
        {
            if (!this.enabled)
            {
                return;
            }

            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(this.transform.position, this.radius.Reactive.Value);
        }
    }
}