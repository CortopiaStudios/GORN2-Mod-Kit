// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Effects;
using UnityEngine;

namespace Cortopia.Scripts.FX
{
    [CreateAssetMenu(menuName = "Cortopia/Physic Material FX")]
    public class PhysicMaterialFX : ScriptableObject
    {
        [SerializeField]
        private MaterialFX[] materialFx;

        [Serializable]
        private struct MaterialFX
        {
            public PhysicMaterial material;
            public AirFixedHitFXSpawner fx;
        }
    }
}