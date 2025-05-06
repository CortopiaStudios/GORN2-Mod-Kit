// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine.AddressableAssets;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.AddressableProperties
{
    public class AddressablePropertyReference<T> : AddressableProperty where T : Object
    {
        public WritableBoundValue<T> property;
        public AssetReferenceT<T> value;

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