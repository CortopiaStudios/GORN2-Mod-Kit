// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

namespace Cortopia.Scripts.Interaction
{
    public class CrossPlatformXRController : ActionBasedController
    {
        [SerializeField]
        // ReSharper disable once NotAccessedField.Local
        private Quaternion steamVRRotationOffset = Quaternion.identity;
        [SerializeField]
        // ReSharper disable once NotAccessedField.Local
        private bool createTrackedPoseDriverSteam = true;
    }
}