// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.BehaviorTree.Spawning;
using Cortopia.Scripts.Core;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Character
{
    [RequireComponent(typeof(SingleSpawner))]
    public class ArmorSetSpawner : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> armorRoot = new();
        [SerializeField]
        private BoundValue<ArmorLocationFlags> armorLocations = new();
        [SerializeField]
        private Transform physicalBodyRoot;

        public Reactive<AssetReferenceGameObject> Prefab => new();

        public Reactive<string> ArmorName => new();

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