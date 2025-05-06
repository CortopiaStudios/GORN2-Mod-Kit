// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    [RequireComponent(typeof(LineRenderer))]
    public class LineRendererTransformTarget : MonoBehaviour
    {
        [SerializeField]
        [ReadOnly]
        private LineRenderer lineRenderer;

        [SerializeField]
        private Transform target;

        private void Update()
        {
            throw new NotImplementedException();
        }

        public void UpdatePositions()
        {
            throw new NotImplementedException();
        }
    }
}