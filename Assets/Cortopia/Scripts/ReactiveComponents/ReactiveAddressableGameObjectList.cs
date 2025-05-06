// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveAddressableGameObjectList : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> index;

        [SerializeField]
        private List<AssetReferenceGameObject> items;

        public Reactive<AssetReferenceGameObject> SelectedItem => default;

        public int Count => default;
    }
}