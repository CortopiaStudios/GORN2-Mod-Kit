// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    public class CrowdPlacementToolInstance : MonoBehaviour
    {
        [SerializeField]
        private float length = 10.0f;
        [SerializeField]
        private float space = 1.2f;
        [SerializeField]
        private float randomFactorSpace;
        [SerializeField]
        private float depth = 0.5f;
        [SerializeField]
        private bool applySavedColors = true;
        [Space]
        [SerializeField]
        private bool drawDebugLines;
    }
}