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
    public class SingleSpawner : Spawner
    {
        public BoundValue<AssetReferenceGameObject> prefab;

        [SerializeField]
        private BoundValue<string> address;

        [Tooltip(
            "Spawn the object as a child of the spawner. True means that future movement of the spawner will affect the spawned object, while false means it will not.")]
        public bool spawnAsChild;

        [SerializeField]
        private BoundValue<Transform> spawnLocation;

        public Reactive<GameObject> SpawnedObject => new();

        public Reactive<bool> IsFullySpawned => new();

        public override bool AllowOutParameters => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        ///     Despawn the currently spawned object. If the spawner is still enabled, a new object will not be spawned until this
        ///     is disabled and re-enabled, or another prefab address is selected.
        /// </summary>
        public void ForceDespawn()
        {
            throw new NotImplementedException();
        }
    }
}