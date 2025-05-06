// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    [RequireComponent(typeof(ConfigurableJoint))]
    public class ReactorConfigurableJointAnchor : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> condition;

        [SerializeField]
        private Vector3 onTrue;

        [SerializeField]
        private Vector3 onFalse;

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