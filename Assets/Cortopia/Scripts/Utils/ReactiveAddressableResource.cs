// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Utils
{
    public class ReactiveAddressableResource : MonoBehaviour
    {
        private const string HelpBoxMessage = "Serialized AssetReferences cannot change value during runtime." +
                                              "\nIf you intend to change the value, use the string key instead.";

        [HelpBox(HelpBoxMessage, HelpBoxMessageType.Warning)]
        [Space]
        [SerializeField]
        private AssetReference asset;

        [SerializeField]
        private BoundValue<string> key;

        public Reactive<Object> LoadedAsset => default;

        public Reactive<GameObject> LoadedGameObject => default;

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