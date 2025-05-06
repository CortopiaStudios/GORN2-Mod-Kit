// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class BrainBossLaserAttackFollowTarget : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> targetObjectTransform;
        [SerializeField]
        private Transform followingTransform;
        [SerializeField]
        [Tooltip("The amount of time that following transform is falling behind the target transform")]
        private float offsetInTime = 2.0f;

        private void FixedUpdate()
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
    }
}