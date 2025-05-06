// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public class PlayerEnemyPseudoCollider : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive = new(true);

        [HelpBox("This object is used to define a radius within which the player can move, but not closer to the center of the object. " +
                 "\nThis is intended for adding collision between the player and NPCs." +
                 "\n\nAll settings should be based on the enemy at scale = 1; these will then scale automatically.")]
        [SerializeField]
        private Transform scaleTransform;

        [Tooltip("The radius to use when the player's scale == 0.2 (interpolation is unclamped, so scale < 0.2 will continue to scale down the radius)")]
        [SerializeField]
        private float collisionRadiusMin = 0.5f;

        [Tooltip("The radius to use when the player is at their default scale (1).")]
        [SerializeField]
        private float collisionRadiusDefault = 1f;

        [Tooltip("The radius to use when the player's scale == 5 (interpolation is unclamped, so scale > 5 will continue to scale up the radius)")]
        [SerializeField]
        private float collisionRadiusMax = 2f;

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