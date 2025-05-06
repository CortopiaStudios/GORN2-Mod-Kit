// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay.Weapons
{
    public class WeaponForwardSpeedBooster : MonoBehaviour
    {
        [HelpBox("This script gives the weapon a speed boost to the player when moving forwards and grabbing it with both hands.")]
        [SerializeField]
        private float multiplier = 1f;

        [Tooltip("The direction towards the tip of the weapon, essentially.")]
        [SerializeField]
        private Vector3 forwardAxis;

        public float Multiplier => default;
        public Vector3 WeaponPointyDirection => default;
    }
}