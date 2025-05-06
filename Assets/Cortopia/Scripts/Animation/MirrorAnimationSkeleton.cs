// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class MirrorAnimationSkeleton : MonoBehaviour
    {
        [SerializeField]
        private Mapping[] bones;
        [HelpBox("Deprecated. Using MirrorTransforms instead.", HelpBoxMessageType.Warning)]
        [SerializeField]
        private Transform proxyRoot;
        [SerializeField]
        private Transform slaveRoot;

        private void LateUpdate()
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private struct Mapping
        {
            public Transform proxy;
            public Transform slave;
        }
    }
}