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
    public class BrainBossMoveTowardsEnemyBehavior : BehaviorTreeBase
    {
        [Header("References")]
        [SerializeField]
        private BoundValue<Transform> forwardReference;
        [SerializeField]
        private BoundValue<TetherFastening> tetherFastenings;
        [SerializeField]
        private BoundValue<int> numberEnemiesAlive;

        [Header("Target")]
        [SerializeField]
        private NavMeshAgentType navMeshAgentType;
        [SerializeField]
        private float navMeshCheckEdgeDistance = 0.2f;
        [SerializeField]
        private float connectDistanceThreshold = 2.0f;
        [SerializeField]
        private float rotationDifferenceThreshold = 5.0f;

        [Header("Speed")]
        [SerializeField]
        private float maxMoveSpeed = 1.0f;
        [SerializeField]
        private float maxTurnSpeed = 1.0f;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<float> forwardSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<float> turnSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<int> connectedEnemiesCount = new(0);

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