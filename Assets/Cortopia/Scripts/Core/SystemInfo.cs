// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Core
{
    public class SystemInfo : MonoBehaviour
    {
        [SerializeField]
        [UsedImplicitly]
        private WritableBoundValue<bool> isPlatformOculus;
        [SerializeField]
        [UsedImplicitly]
        private WritableBoundValue<bool> isPlatformSteam;

        [Tooltip("Checks for current device name.")]
        [SerializeField]
        private DeviceNameCondition[] deviceNameConditions;

        [Serializable]
        private struct DeviceNameCondition
        {
            [Tooltip("Check if the name is contained in the device name, for example \"Quest\" is contained in the device name \"Quest 3\".")]
            public string containsName;
            [Tooltip("The result.")]
            public WritableBoundValue<bool> result;
        }
    }
}