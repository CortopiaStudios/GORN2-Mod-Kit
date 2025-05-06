// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class ChainAnimation : MonoBehaviour
    {
        [SerializeField]
        private Transform parent;
        [SerializeField]
        private ConfigurableJoint joint;
        [SerializeField]
        private Transform[] rings;
        [SerializeField]
        private Vector3 weaponUp;

        private void LateUpdate()
        {
            throw new NotImplementedException();
        }
    }
}