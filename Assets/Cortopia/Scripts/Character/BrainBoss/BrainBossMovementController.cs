// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class BrainBossMovementController : MonoBehaviour
    {
        [Header("Movement")]
        [SerializeField]
        private Transform forwardTransform;
        [SerializeField]
        private BoundValue<float> targetMoveSpeed;
        [SerializeField]
        private BoundValue<float> targetTurnSpeed;
        [SerializeField]
        private BoundValue<float> moveAcceleration = new(1f);
        [SerializeField]
        [Tooltip("Vertical speed for continuous ping-pong movement")]
        private float verticalSpeed = 0.5f;
        [SerializeField]
        [Tooltip("Vertical offset for continuous ping-pong movement")]
        private float verticalOffset = 1.0f;
        [Header("Set Position")]
        [SerializeField]
        private Transform target;

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void FixedUpdate()
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

        public void SetPosition(Transform transformToUpdate)
        {
            throw new NotImplementedException();
        }
    }
}