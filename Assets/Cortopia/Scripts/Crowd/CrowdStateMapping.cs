// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    [Serializable]
    public struct CrowdStateMapping
    {
        public string stateValue;

        public AnimationCurve probability;
        public float minInput;
        public float maxInput;
    }
}