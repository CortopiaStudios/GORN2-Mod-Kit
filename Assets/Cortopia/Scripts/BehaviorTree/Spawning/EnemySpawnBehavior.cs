// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Arena;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.BehaviorTree.Spawning
{
    [Flags]
    public enum ArmorLocationFlags
    {
        None = 0,
        Helmet = 1,
        RightShoulder = 2,
        LeftShoulder = 4,
        RightUpperArm = 8,
        LeftUpperArm = 16,
        RightForearm = 32,
        LeftForearm = 64,
        RightGlove = 128,
        LeftGlove = 256,
        Torso = 512,
        Trunks = 1024,
        RightUpperLeg = 2048,
        LeftUpperLeg = 4096,
        RightLowerLeg = 8192,
        LeftLowerLeg = 16384,
        RightBoot = 32768,
        LeftBoot = 65536
    }

    public enum ArmorLocation
    {
        None = 0,
        Helmet = 1,
        RightShoulder = 2,
        LeftShoulder = 4,
        RightUpperArm = 8,
        LeftUpperArm = 16,
        RightForearm = 32,
        LeftForearm = 64,
        RightGlove = 128,
        LeftGlove = 256,
        Torso = 512,
        Trunks = 1024,
        RightUpperLeg = 2048,
        LeftUpperLeg = 4096,
        RightLowerLeg = 8192,
        LeftLowerLeg = 16384,
        RightBoot = 32768,
        LeftBoot = 65536
    }

    [Serializable]
    public struct EnemyEquipmentSet
    {
        public BoundValue<AssetReferenceGameObject> prefab;
        public BoundValue<ArmorLocationFlags> armorLocationsFlag;
    }

    [Serializable]
    public struct EnemyWeaponSet
    {
        public BoundValue<AssetReferenceGameObject> prefabRight;
        public BoundValue<AssetReferenceGameObject> prefabLeft;
    }

    public class EnemySpawnBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<ArenaController> arenaController;
        [SerializeField]
        private AssetReferenceGameObject enemyPrefab;
        [SerializeField]
        private BoundValue<Transform> spawnPosition;
        [SerializeField]
        private int enemyAmount = 1;
        [SerializeField]
        [Tooltip("If the character have a custom scale, this setting should probably be disabled.")]
        private bool initializeScaleController = true;
        [SerializeField]
        private float minScale = 0.8f;
        [SerializeField]
        private float maxScale = 1.2f;
        [SerializeField]
        private EnemyEquipmentSet equipmentSet;
        [SerializeField]
        private EnemyWeaponSet weaponSet;
        [Space]
        [SerializeField]
        private bool awaitAllDead;

        [UsedImplicitly]
        public Reactive<int> EnemiesAlive => new();

        [UsedImplicitly]
        public Reactive<bool> AnyEnemiesAlive => new();

        [UsedImplicitly]
        public Reactive<bool> NoEnemyAlive => new();

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void SetMinScale(float scale)
        {
            throw new NotImplementedException();
        }

        public void SetMaxScale(float scale)
        {
            throw new NotImplementedException();
        }

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}