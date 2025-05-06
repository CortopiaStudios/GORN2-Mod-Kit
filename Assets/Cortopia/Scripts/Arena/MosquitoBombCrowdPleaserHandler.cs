// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Arena
{
    public class MosquitoBombCrowdPleaserHandler : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> rokibeHitByBomb;

        [Space]
        [SerializeField]
        private int successCount;

        [Space]
        [SerializeField]
        private UnityEvent onIncrementCount;

        public Reactive<int> HitCount => new();

        public Reactive<bool> Success => new();

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