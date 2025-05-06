// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.CleanupSystem;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Arena
{
    public class ArenaController : MonoBehaviour
    {
        [SerializeField]
        private Transform[] spawningPoints;
        [SerializeField]
        [CanBeNull]
        private CleanupQueue deadEnemiesCleanupQueue;
        [SerializeField]
        [Tooltip("The number of seconds before a previously used random spawn point is free again.")]
        private float freeRandomSpawnPointDelay = 12;

        public Reactive<IntegerCounter> EnemyDied => new();
        public Reactive<int> EnemiesAlive => new();

        private void Update()
        {
            throw new NotImplementedException();
        }

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