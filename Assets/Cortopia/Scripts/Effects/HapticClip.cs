// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Effects
{
    [Serializable]
    public struct HapticClip
    {
        [Range(0, 1)]
        public float amplitude;
        [Tooltip("This does not work on Quest controllers.")]
        [Range(0, 300)]
        public float frequency;
        public float duration;
    }
}