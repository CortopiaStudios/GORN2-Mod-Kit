// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.AI.Navigation;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BoneBoss
{
    public class BoneBossSpinAttackMovement : MonoBehaviour
    {
        [Space]
        [SerializeField]
        private float duration = 10f;

        [Header("Speed")]
        [SerializeField]
        private float maxSpeed = 5;

        [Tooltip("This curve can be used to modify the max speed over time. It's recommended to keep this value in-between 0 and 1.")]
        [SerializeField]
        private AnimationCurve maxSpeedOverTimeMod;

        [SerializeField]
        private float acceleration = 0.025f;

        [Header("Turning")]
        [Tooltip("The distance from the player at which to apply minimum turn strength. This helps to ensure that the boss doesn't stop moving when close to the player.")]
        [SerializeField]
        private float minTurnStrengthDistance = 3f;

        [Tooltip("The distance from the player at which to apply maximum turn strength. This helps in returning the boss to the player when far away.")]
        [SerializeField]
        private float maxTurnStrengthDistance = 5f;

        [Tooltip("How much to multiply speed when the boss is using its maximum turn strength. This helps make turns sharper.")]
        [SerializeField]
        private float turnStrengthSpeedMod = 2f;

        [Header("Leaning")]
        [Tooltip("How much the boss should lean in the direction of motion at the most. The actual angle will depend on the speed.")]
        [SerializeField]
        private float leanAngle = 15f;

        [Tooltip("How much to offset the boss on the Y-axis when fully leaning. This can help to avoid the feet clipping through the floor.")]
        [SerializeField]
        private float leanHeightOffset = 0.05f;

        [Header("Obstacle Bouncing")]
        [SerializeField]
        private LayerMask bounceLayers;

        [Tooltip("How far to RayCast to try to find obstacles to bounce off of. Currently the boss only RayCasts in its movement direction.")]
        [SerializeField]
        private BoundValue<float> checkForObstaclesDistance;

        [SerializeField]
        private float onBounceSpeedMod = 0.5f;

        [Space]
        [Header("Input")]
        [SerializeField]
        private BoundValue<bool> isFullySpinning;

        [SerializeField]
        private BoundValue<Transform> moveTransform;

        [SerializeField]
        private BoundValue<Transform> playerTransform;

        [SerializeField]
        private BoundValue<NavMeshAgentType> navMeshAgentType;

        [Header("Output")]
        [SerializeField]
        private WritableBoundValue<bool> continueSpinning;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void StartMovement()
        {
            throw new NotImplementedException();
        }
    }
}