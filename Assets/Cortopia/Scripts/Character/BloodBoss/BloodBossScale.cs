// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BloodBoss
{
    public class BloodBossScale : MonoBehaviour
    {
        [SerializeField]
        private float scalingFactor = 0.9f;
        [SerializeField]
        private float scalingTime = 4.0f;
        [SerializeField]
        private BoundValue<bool> scalingTrigger;
        [Space]
        [SerializeField]
        private BloodBossMovementSemiPhysics movementController;
        [SerializeField]
        private Transform[] objectsToScale;
        [SerializeField]
        private Transform[] objectsToScaleReverse;
        [SerializeField]
        [Tooltip("Scales joint positions for connected anchors when autoConfigureConnectedAnchors should be inactivated")]
        private ConfigurableJoint[] jointsScaleConnectedPosition;

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