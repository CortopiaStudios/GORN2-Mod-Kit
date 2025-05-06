// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class JointDriveController : MonoBehaviour
    {
        [SerializeField]
        [CanBeNull]
        private ConfigurableJoint joint;
        [Space]
        [SerializeField]
        private BoundValue<float> tension = new();
        [SerializeField]
        private bool defaultValues;
        [SerializeField]
        private float minDrivePositionSpring = 1000;
        [SerializeField]
        private float minDrivePositionDamper = 100;

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