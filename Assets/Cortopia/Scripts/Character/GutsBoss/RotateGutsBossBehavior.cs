// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.GutsBoss
{
    public class RotateGutsBossBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private WritableBoundValue<float> rotation;
        [SerializeField]
        private Transform gutsBoss;
        [SerializeField]
        private BoundValue<Transform> target;
        [SerializeField]
        private BoundValue<float> speed;
        [SerializeField]
        [Tooltip("The min angle between boss and target that will be mapped to the minAngle value")]
        private float minAngle;
        [SerializeField]
        [Tooltip("The max angle between boss and target that will be mapped to the maxAngle value")]
        private float maxAngle;
        [SerializeField]
        private float minMapAngleValue;
        [SerializeField]
        private float maxMapAngleValue;
        [SerializeField]
        [Tooltip("The mapped value is adjusted with a random value in the range of this value plus/minus")]
        private float mapRandomValue;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}