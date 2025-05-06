// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class ProjectileLauncherAutoAim : MonoBehaviour
    {
        [HelpBox(
            "This component will take the angle from the forward vector to the target, and output a new local direction that is closer to it. Connect the output Reactive to a Projectile Launcher to forcibly improve aiming.")]
        [SerializeField]
        private BoundValue<bool> isActive;

        [SerializeField]
        private BoundValue<Transform> target;

        [SerializeField]
        private BoundValue<float> angleThreshold;

        [Tooltip(
            "A value between 0-1 that determines how much to fudge the returned vector. A value of 0 will return the original forward vector - a value of 1 will return the direction to the target.")]
        [SerializeField]
        private BoundValue<float> fudging;

        public Reactive<Vector3> LocalFudgedDirection => default;

        private void Update()
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