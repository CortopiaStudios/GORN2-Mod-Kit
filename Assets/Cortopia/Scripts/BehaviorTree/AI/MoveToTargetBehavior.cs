// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.AI.Navigation;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.BehaviorTree.AI
{
    public class MoveToTargetBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private PlayerLoopTiming playerLoopTiming = PlayerLoopTiming.FixedUpdate;
        [SerializeField]
        private CompletionMode completionMode = CompletionMode.SucceedOnTarget;
        [SerializeField]
        private BoundValue<NavMeshAgentType> navMeshAgentType;

        [Space]
        [SerializeField]
        private BoundValue<Transform> forwardReference;
        [SerializeField]
        private BoundValue<Transform> target;
        [SerializeField]
        private float pathDistanceCheck = 0.6f;
        [SerializeField]
        [Tooltip("Ignore IgnorableNavMeshObstacles or not.")]
        private BoundValue<bool> ignoreNavMeshObstacles;

        [Header("Speed")]
        [SerializeField]
        private BoundValue<float> maxMoveSpeed = new(1f);
        [SerializeField]
        private BoundValue<float> maxStrafeSpeed = new(1f);
        [SerializeField]
        private float withinDesiredDistanceMoveSpeed;

        [Header("Turning")]
        [SerializeField]
        private BoundValue<float> maxTurnSpeed = new(1f);
        [SerializeField]
        private float startTurnAngleThreshold = 45f;

        [Header("Distance")]
        [Tooltip("The distance the agent should try to keep from the target.")]
        [SerializeField]
        private BoundValue<float> desiredDistance;
        [Tooltip("How far from desiredDistance the agent has to be before stopping.")]
        [SerializeField]
        private BoundValue<float> desiredDistanceEnterMargin;
        [Tooltip("How far from desiredDistance the agent has to be before moving towards desiredDistance again.")]
        [SerializeField]
        private BoundValue<float> desiredDistanceExitMargin;
        [Tooltip("If true, the agent will strafe in a random direction, circling the target, when within the desired distance.")]
        [SerializeField]
        private bool strafeAroundTargetWhenClose;
        [Tooltip("If strafing around the target, how many seconds before the agent should change direction?")]
        [SerializeField]
        private float secondsPerStrafeDirection;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<float> forwardSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<float> strafeSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<float> turnSpeed = new(0f);

        public Reactive<float> Turn => new();

        public Reactive<float> ForwardSpeed => new();

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }

        private enum CompletionMode
        {
            SucceedOnTarget,
            KeepDistanceToTarget
        }
    }
}