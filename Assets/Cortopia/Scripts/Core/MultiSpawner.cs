// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.Events;

namespace Cortopia.Scripts.Core
{
    public class MultiSpawner : Spawner
    {
        public BoundValue<AssetReferenceGameObject> prefab;

        [SerializeField]
        private BoundValue<string> address;

        [Tooltip(
            "Spawn the object as a child of the spawner. True means that future movement of the spawner will affect the spawned object, while false means it will not.")]
        public bool spawnAsChild;

        [Space]
        [SerializeField]
        private UnityEvent<GameObject> onSpawnedObject;

        public override bool AllowOutParameters => default;

        public void SpawnAt(Transform poseTransform)
        {
            throw new NotImplementedException();
        }
    }
}