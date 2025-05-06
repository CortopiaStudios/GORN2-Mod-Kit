// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Core
{
    public class SceneLoader : MonoBehaviour
    {
        [Tooltip("A static reference that takes precedence over the reactive scene")]
        [SerializeField]
        private AssetReference sceneReference;
        [Tooltip("A dynamic scene reference that is used in case the scene reference is not set")]
        [SerializeField]
        private BoundValue<string> scene;
        [SerializeField]
        private BoundValue<bool> load;
        [SerializeField]
        private Color fadeColor = Color.black;
        [SerializeField]
        private BoundValue<bool> shouldPreLoad;
        [SerializeField]
        private float minLoadTimeDuration;

        [SerializeField]
        private bool showTip = true;

        public Reactive<bool> IsLoading => new();

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void Load()
        {
            throw new NotImplementedException();
        }
    }
}