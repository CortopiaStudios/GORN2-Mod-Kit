// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class TetherFastening : MonoBehaviour
    {
        public static TetherFastening Instance;
        [SerializeField]
        private BoundValue<bool> removeAllTethersTrigger;
        [SerializeField]
        private Transform centerAttachPoint;
        [SerializeField]
        private GameObject tetherPrefab;
        [SerializeField]
        private bool showDebugLines;
        [SerializeField]
        private LayerMask layer;
        [Space]
        [Header("Graphics fastening points")]
        [SerializeField]
        [Tooltip("The height offset from the anchor attach points, meters")]
        private float heightOffsetAnchor = 0.9f;
        [SerializeField]
        [Tooltip("The height offset from the center attach points, meters")]
        private float heightOffsetCenter = -0.3f;
        [SerializeField]
        [Tooltip("The length offset from end points of the anchor attach points, meters")]
        private float lengthOffsetAnchor = 1.0f;
        [SerializeField]
        [Tooltip("The length offset from the center anchor end points, meters")]
        private float lengthOffsetCenter = 0.3f;
        [SerializeField]
        private float randomFactorHeight = 0.5f;
        [SerializeField]
        private float randomFactorLength = 0.8f;

        public UnityEvent<Tether> onTetherAdded = new();
        public UnityEvent<Tether> onTetherDestroyed = new();

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

        public void RemoveTether(TetherAnchor anchor)
        {
            throw new NotImplementedException();
        }

        public void AddTether(TetherAnchor tetherAnchor)
        {
            throw new NotImplementedException();
        }
    }

    public class Tether
    {
    }
}