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
    public class ReactorConfigurableJointMotion : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> condition;

        [Header("Motion")]
        [SerializeField]
        private Motion motionOnTrue;

        [SerializeField]
        private Motion motionOnFalse;

        [Header("Angular Motion")]
        [SerializeField]
        private Motion angularMotionOnTrue;

        [SerializeField]
        private Motion angularMotionOnFalse;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private class Motion
        {
            public ConfigurableJointMotion x;
            public ConfigurableJointMotion y;
            public ConfigurableJointMotion z;
        }
    }
}