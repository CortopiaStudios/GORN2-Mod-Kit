// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Reactivity.Singletons;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.AddressableProperties
{
    public class AddressablePropertyValue<T> : AddressableProperty
    {
        public WritableBoundValue<T> property;
        public AssetReferenceT<GlobalVariable<T>> value;
        [SerializeField]
        private bool reloadOnEnable;

        public Reactive<T> Value => new();

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