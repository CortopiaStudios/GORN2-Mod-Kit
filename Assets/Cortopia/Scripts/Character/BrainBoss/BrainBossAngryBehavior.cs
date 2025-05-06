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
    public class BrainBossAngryBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private AnimationCurve rotationSpeedCurve;
        [SerializeField]
        private float maxSpeed = 150.0f;
        [SerializeField]
        private AnimationCurve brainColorIntensity;
        [SerializeField]
        private float time = 6.0f;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<float> turnSpeed = new(0f);
        [SerializeField]
        private WritableBoundValue<float> materialIntensity = new(0f);

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}