// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.AI
{
    public class RotateToTargetBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private PlayerLoopTiming playerLoopTiming = PlayerLoopTiming.FixedUpdate;
        [SerializeField]
        private CompletionMode completionMode = CompletionMode.SucceedOnTarget;
        [Space]
        [SerializeField]
        private BoundValue<Transform> forwardReference;
        [SerializeField]
        private BoundValue<Transform> target;

        [SerializeField]
        private BoundValue<float> minTurnSpeed = new(0.1f);
        [SerializeField]
        private BoundValue<float> maxTurnSpeed = new(1f);
        [Tooltip("The angle to the target at which the maximum turn speed will be output.")]
        [SerializeField]
        private BoundValue<float> maxTurnSpeedAngle = new(45);
        [Tooltip("How close to get to the target.")]
        [SerializeField]
        private BoundValue<float> minTargetAngle = new(10);

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<float> turnSpeed = new(0f);

        public Reactive<float> Turn => new();

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }

        private enum CompletionMode
        {
            SucceedOnTarget,
            KeepRotateToTarget
        }
    }
}