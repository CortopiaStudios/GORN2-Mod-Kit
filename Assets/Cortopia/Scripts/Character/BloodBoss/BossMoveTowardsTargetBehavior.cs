// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BloodBoss
{
    public class BossMoveTowardsTargetBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<Transform> forwardReference;
        [SerializeField]
        private BoundValue<Transform> targetReference;
        [SerializeField]
        private BoundValue<float> rotationDifferenceThreshold = new(5);
        [SerializeField]
        private BoundValue<float> maxMoveSpeed = new(1);
        [SerializeField]
        private BoundValue<float> maxTurnSpeed = new(1);
        [SerializeField]
        private Mode movementMode = Mode.MoveOrRotate;
        [SerializeField]
        private bool showDebugLines;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<float> forwardSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<float> turnSpeed = new(0f);

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }

        private enum Mode
        {
            MoveOrRotate,
            MoveAndRotate
        }
    }
}