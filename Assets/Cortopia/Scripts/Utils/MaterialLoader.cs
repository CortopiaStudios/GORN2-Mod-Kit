// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Utils
{
    public class MaterialLoader : MonoBehaviour
    {
        [SerializeField]
        private AssetReferenceT<Material> standard;
        [SerializeField]
        private AssetReferenceT<Material> simple;

        public Reactive<Material> LoadedMaterial => default;

        private void Start()
        {
            throw new NotImplementedException();
        }
    }
}