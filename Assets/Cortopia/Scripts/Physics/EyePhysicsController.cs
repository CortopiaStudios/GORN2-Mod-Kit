// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Animation;
using Cortopia.Scripts.Gore;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(ActiveJoint))]
    public class EyePhysicsController : MonoBehaviour
    {
        [HelpBox("This component should be put on the eye physics object. It handles joint activation of the eye")]
        [SerializeField]
        private BoundValue<Transform> eyeController;
        [SerializeField]
        private EyeSide eyeSide;
        [SerializeField]
        private EyePop eyePop;
        [SerializeField]
        private DamageScaleAnimation damageAnimation;

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        private enum EyeSide
        {
            Left,
            Right
        }
    }
}