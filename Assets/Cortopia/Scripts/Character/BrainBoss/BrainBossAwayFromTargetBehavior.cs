// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.AI.Navigation;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class BrainBossAwayFromTargetBehavior : BehaviorTreeBase
    {
        [Header("Reference")]
        [SerializeField]
        private BoundValue<Transform> forwardReference;
        [SerializeField]
        private BoundValue<Transform> targetReference;
        [SerializeField]
        private NavMeshAgentType navMeshAgentType;
        [SerializeField]
        private BoundValue<int> numberEnemiesAlive;
        [Header("Target")]
        [SerializeField]
        private float minTurnAngle;
        [SerializeField]
        private float maxTurnAngle = 25.0f;
        [SerializeField]
        private float minNewTargetDistance = 4.0f;
        [SerializeField]
        private float maxNewTargetDistance = 6.0f;
        [SerializeField]
        private float navMeshCheckEdgeDistance = 0.3f;
        [SerializeField]
        [Tooltip("If the boss is within this distance from the target it will try to fly in opposite direction " +
                 "when choosing a new destination, otherwise it continues in forward direction, a random angle offset is added")]
        private float minMoveAwayFromPlayerDistance = 3.5f;
        [SerializeField]
        [Tooltip("If the boss has not reached the target destination within this time, a new target destination is set")]
        private float maxTargetDestinationTime = 7.0f;
        [SerializeField]
        [Tooltip("The minimum distance to target reference which triggers a new target position")]
        private float distanceDifferenceThreshold = 3.0f;
        [SerializeField]
        private float rotationDifferenceThreshold = 15.0f;

        [Header("Speed")]
        [SerializeField]
        private float maxMoveSpeed = 2.5f;
        [SerializeField]
        private float maxTurnSpeed = 40.0f;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<float> forwardSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<float> turnSpeed = new(0f);

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}