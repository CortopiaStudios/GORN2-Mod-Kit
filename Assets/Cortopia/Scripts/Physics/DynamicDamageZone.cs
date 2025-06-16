// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public class DynamicDamageZone : MonoBehaviour
    {
        [HelpBox(
            "The DynamicDamageZone component is responsible for dealing damage to objects that intersect with its movement path during physics updates. It is designed for use in fast-moving or dynamic objects, such as weapons or hazards, where normal collision-based damage detection may miss contacts due to high speed.")]
        [Tooltip("Applies a fixed amount of damage (damage) each physics frame (FixedUpdate) to objects it hits.")]
        public float damage = 10;

        [Space]
        [Tooltip(
            "Uses the velocity of the assigned Rigidbody to determine the direction and distance of a shape cast.")]
        public new Rigidbody rigidbody;

        [Tooltip("Only objects within the specified layerMask are considered for damage.")]
        public LayerMask layerMask;

        [Tooltip(
            "Performs shape-based raycasts (ShapeCast) using multiple colliders in castColliders to simulate the physical extent of the damage zone.")]
        public Collider[] castColliders;

        private void FixedUpdate()
        {
            // Not implemented
        }
    }
}