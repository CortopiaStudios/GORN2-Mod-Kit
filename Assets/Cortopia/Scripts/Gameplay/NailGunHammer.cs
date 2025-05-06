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
    public class NailGunHammer : MonoBehaviour
    {
        [HelpBox("This script is used to emulate the hammer on a gun, for visual purposes.")]
        [Space]
        [SerializeField]
        private BoundValue<IntegerCounter> triggerEvent;

        [SerializeField]
        private BoundValue<Vector3> targetRotation;

        [SerializeField]
        private BoundValue<float> postRotationDelay;

        [Tooltip("The time in seconds that it takes for the hammer to go from its starting rotation to the target rotation.")]
        [SerializeField]
        private BoundValue<float> rotationTime;

        [Tooltip("The time in seconds that it takes for the hammer to go from its target rotation back to its start rotation.")]
        [SerializeField]
        private BoundValue<float> returnTime;

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