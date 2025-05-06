// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [RequireComponent(typeof(ConfigurableJoint))]
    public class JointDriveActivator : MonoBehaviour
    {
        private JointDrive _angularXDrive;
        private JointDrive _angularYZDrive;
        private JointDrive _slerpDrive;
        private JointDrive _xDrive;
        private JointDrive _yDrive;
        private JointDrive _zDrive;

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