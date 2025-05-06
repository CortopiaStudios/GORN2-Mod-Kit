// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class SpawnHubRokibes : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<IntegerCounter> spawnTrigger = new(default(IntegerCounter));
        [SerializeField]
        private BoundValue<GameObject> rokibeAnimationPrefab;
        [SerializeField]
        private BoundValue<float> maxTimeBetweenSpawns;
        [SerializeField]
        private BoundValue<float> minTimeBetweenSpawns;
        [SerializeField]
        private BoundValue<float> animationLifeTime;
        [SerializeField]
        [Tooltip("The last index of the elements in the spawn rotations list that will be used, the first element is index 0")]
        private BoundValue<int> lastIndex;
        [SerializeField]
        private BoundValue<Vector3>[] spawnRotations;

        public Reactive<bool> IsPlaying => new();

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