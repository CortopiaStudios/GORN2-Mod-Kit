// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class ClosestTargetFinder : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive = new(false);

        [SerializeField]
        private BoundValue<bool> canTargetPlayer = new(true);

        [SerializeField]
        private BoundValue<GameObject> playerCamera;

        [Tooltip("How much closer a new candidate has to be than the currently chosen target, for it to be considered. Prevents jumping between two targets quickly.")]
        [SerializeField]
        private BoundValue<float> distanceThreshold = new(1f);

        [Tooltip("How many seconds between each update of the closest target.")]
        [SerializeField]
        private BoundValue<float> latency = new(1f);

        public Reactive<Transform> ClosestTarget => new();

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void LateUpdate()
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