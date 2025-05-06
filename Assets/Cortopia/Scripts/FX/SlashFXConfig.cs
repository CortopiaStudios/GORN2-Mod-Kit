// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using System.Threading;
using Cortopia.Scripts.Core;
using Cortopia.Scripts.Debugging;
using Cortopia.Scripts.Effects;
using Cortopia.Scripts.Gore;
using Cortopia.Scripts.Painting;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Cortopia.Scripts.FX
{
    [CreateAssetMenu(menuName = "Cortopia/Slash FX Config")]
    public class SlashFXConfig : ScriptableObject
    {
        [Header("FX")]
        [SerializeField]
        private PhysicMaterialFxMap slashEffects;

        [Header("Cuts")]
        [SerializeField]
        private bool paintCuts = true;
        [SerializeField]
        private float slashCutWidth = 0.044f;
        [SerializeField]
        [Tooltip("The factor of the total blade length that will give slash cuts, starting from the tip")]
        private float slashLengthFactor = 0.4f;
        [SerializeField]
        private float slashLengthRandomFactor = 0.2f;
        [SerializeField]
        private float slashCutStartOffset = -0.1f;
        [SerializeField]
        private float slashCutStrength = 1;
        [SerializeField]
        private float slashCutHardness = 1;
        [SerializeField]
        private Color slashCutPaintColor;
    }
}