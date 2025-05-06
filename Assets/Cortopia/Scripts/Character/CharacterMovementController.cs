// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.Navigation;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class CharacterMovementController : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<NavMeshAgentType> navMeshAgentType;

        [Space]
        [SerializeField]
        private BoundValue<float> targetMoveSpeed;
        [SerializeField]
        private BoundValue<float> targetStrafeSpeed;
        [SerializeField]
        private BoundValue<float> targetTurnSpeed;
        [SerializeField]
        private BoundValue<bool> hasTurnAnimation = new(true);
        [Space]
        [SerializeField]
        private BoundValue<float> moveAcceleration = new(1f);
        [SerializeField]
        private BoundValue<float> strafeAcceleration = new(1f);
        [Space]
        [Header("Optional non-physics")]
        // [CanBeNull]
        [SerializeField]
        private Transform rootTransform;
        [SerializeField]
        private BoundValue<float> rootTransformRotationScale = new(45);
        [SerializeField]
        private BoundValue<bool> clampToNavMesh;
        [SerializeField]
        private Directions clampDirections = Directions.All;

        public Reactive<float> ResultMoveSpeed => new();

        public Reactive<float> ResultStrafeSpeed => new();

        public Reactive<float> ResultTurnSpeed => new();

        public Reactive<Vector3> ResultAngularVelocity => new();

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

        [Flags]
        private enum Directions
        {
            X = 1 << 0,
            Y = 1 << 1,
            Z = 1 << 2,
            All = X | Y | Z
        }
    }
}