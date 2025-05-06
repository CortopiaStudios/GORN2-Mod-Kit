// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveSourceAssetReferenceGameObject : MonoBehaviour
    {
        [SerializeField]
        private ReactiveSource<AssetReferenceGameObject> value = new(default(AssetReferenceGameObject));

        public ReactiveSource<AssetReferenceGameObject> Value => this.value;
    }
}