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
    public class BrainBossRandomLookTargetBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<Transform> targetPlayer;
        [SerializeField]
        [Tooltip("The chance that the new look target will be the player")]
        [Range(0.0f, 1.0f)]
        private float chanceLookAtPlayer;
        [SerializeField]
        [Tooltip("The time for lookTargetWeight to go from 1 for the old target to 1 for the new target")]
        private float changeTargetTime;
        [SerializeField]
        private float minTargetTime = 5.0f;
        [SerializeField]
        private float maxTargetTime = 30.0f;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<GameObject> eyeLookTarget;
        [SerializeField]
        private WritableBoundValue<float> lookTargetWeight;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            throw new NotImplementedException();
        }
    }
}