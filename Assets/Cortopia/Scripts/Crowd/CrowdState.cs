// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    public class CrowdState : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> input;

        [SerializeField]
        private string stateName;

        [SerializeField]
        private CrowdStateMapping[] mappings;

        public string StateName => this.stateName;
    }
}