// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    public class CrowdControlSystem : MonoBehaviour
    {
        [SerializeField]
        private CrowdPlacement crowdPlacement;
        [SerializeField]
        private List<CrowdModelSettings> modelSettings;
        [SerializeField]
        private BoundValue<float> crowdSizePercentage = new(1);
        [SerializeField]
        private float scaleVariationMin = 0.9f;
        [SerializeField]
        private float scaleVariationMax = 1.1f;

        public Reactive<float> CrowdSizePercentage => default;

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