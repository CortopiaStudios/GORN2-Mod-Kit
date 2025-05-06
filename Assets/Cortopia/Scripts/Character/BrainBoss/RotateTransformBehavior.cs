// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class RotateTransformBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<Transform> rootTransform;
        [SerializeField]
        private Vector3 localForward = Vector3.forward;
        [SerializeField]
        private TargetType targetType;
        [SerializeField]
        private BoundValue<Transform> targetTransform;
        [SerializeField]
        private BoundValue<Quaternion> targetRotation;
        [SerializeField]
        private Space rotationSpace;

        [SerializeField]
        private BoundValue<float> time;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }

        private enum TargetType
        {
            TargetTransform,
            TargetRotation
        }

        private enum Space
        {
            Local,
            World
        }
    }
}