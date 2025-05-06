// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.FX
{
    [CreateAssetMenu(menuName = "Cortopia/Stab FX Config")]
    public class StabFXConfig : ScriptableObject
    {
        [Header("Stab effect")]
        [SerializeField]
        private LayerMask characterLayer;
        [SerializeField]
        private VelocityToIntensityMap stabEntryVelocityToIntensityMap;
        [SerializeField]
        private VelocityToIntensityMap stabStayVelocityToIntensityMap;
        [SerializeField]
        private VelocityToIntensityMap stabExitVelocityToIntensityMap;
        [SerializeField]
        private PhysicMaterialFxMap stabEffectsAlive;
        [SerializeField]
        private PhysicMaterialFxMap stabEffectsDead;

        [Header("Stab cuts")]
        [SerializeField]
        private bool paintCuts = true;
        [SerializeField]
        private Color stabCutPaintColor;
        [SerializeField]
        private float stabCutRadius = 0.05f;
        [SerializeField]
        private float stabCutStrength = 1;
        [SerializeField]
        private float stabCutHardness = 1;

        [Serializable]
        private struct VelocityToIntensityMap
        {
            public float minVelocity;
            public float maxVelocity;
            public float minIntensity;
            public float maxIntensity;
        }
    }
}