// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Effects;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.FX
{
    [Serializable]
    public struct PhysicMaterialFxMap
    {
        [SerializeField]
        private DefaultFXUsage defaultFXUsage;
        [SerializeField]
        private AirFixedHitFXSpawner defaultFx;
        [SerializeField]
        private Mapping[] materialFx;

        private enum DefaultFXUsage
        {
            AlwaysIncludeDefault,
            DefaultAsFallback,
            ExcludeDefault
        }

        [Serializable]
        private struct Mapping
        {
            public PhysicMaterial material;
            public AssetReferenceT<PhysicMaterial> materialReference;
            public AirFixedHitFXSpawner fx;
        }
    }
}