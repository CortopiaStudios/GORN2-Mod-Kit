// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.FX
{
    [CreateAssetMenu(menuName = "Cortopia/Impact Damage FX Config")]
    public class ImpactFXConfig : ScriptableObject
    {
        [Header("Impact effects")]
        [SerializeField]
        private DamageToIntensityMap impactDamageToIntensityMap;
        [SerializeField]
        private PhysicMaterialFxMap impactEffect;

        [SerializeField]
        private bool paintBruises = true;
        [SerializeField]
        private Color bruisePaintColor;
        [SerializeField]
        private float bruiseRadius = 0.05f;
        [SerializeField]
        private float bruiseStrength = 1;
        [SerializeField]
        private float bruiseHardness = 1;

        [Serializable]
        private struct DamageToIntensityMap
        {
            public float minDamage;
            public float maxDamage;
            public float minIntensity;
            public float maxIntensity;
        }
    }
}