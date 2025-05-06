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
    public class ProjectileLauncherSpread : MonoBehaviour
    {
        [HelpBox(
            "This component will repeatedly output a vector based on its forward vector with some random spread. This is intended to be connected to a Projectile Launcher, to worsen its aim.")]
        [SerializeField]
        private BoundValue<bool> isActive;

        [SerializeField]
        private BoundValue<IntegerCounter> onLaunchProjectile;

        [SerializeField]
        private BoundValue<Vector3> currentLocalAimingDirection = new(Vector3.forward);

        [SerializeField]
        private BoundValue<float> spread = new(45f);

        public Reactive<Vector3> LocalSpreadDirection => default;

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