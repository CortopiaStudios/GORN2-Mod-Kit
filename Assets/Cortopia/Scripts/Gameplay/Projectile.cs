// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics.ObjectUserCollisionHandler;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    [RequireComponent(typeof(ObjectUserCollisionHandler))]
    public class Projectile : MonoBehaviour
    {
        [HelpBox(
            "This script defines a projectile to be used in a Projectile Launcher. It needs to be placed on the object root, but note that it is the Rigidbodies underneath which are actually moved!",
            HelpBoxMessageType.Warning)]
        [Space]
        [Tooltip("When attached to a projectile launcher, this Transform will be used to center the Projectile on the launcher.")]
        // [CanBeNull]
        [SerializeField]
        private Transform nockingPivot;

        public Reactive<bool> IsPreparingOrLaunching => default;

        public Reactive<bool> ShouldDamagePlayer => default;

        public Reactive<bool> IsFlying => default;

        public Reactive<Transform> LaunchFromTransform => default;

        public bool WasLaunchedByPlayer => default;
    }
}