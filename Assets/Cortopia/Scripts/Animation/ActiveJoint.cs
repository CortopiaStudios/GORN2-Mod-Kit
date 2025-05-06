// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Physics;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class ActiveJoint : GravesBehaviour
    {
        [SerializeField]
        [CanBeNull]
        private ConfigurableJoint joint;
        [SerializeField]
        private List<Transform> proxyJoints;
        [SerializeField]
        private float targetPositionBlendAlpha = 1f;
        [SerializeField]
        private Space space;

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }

        public void AddProxyJoint(Transform proxyTransform)
        {
            throw new NotImplementedException();
        }

        public void SetJoint(ConfigurableJoint configurableJoint)
        {
            throw new NotImplementedException();
        }

        private enum Space
        {
            Local,
            World
        }
    }
}