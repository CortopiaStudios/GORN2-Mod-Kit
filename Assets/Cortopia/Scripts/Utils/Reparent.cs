// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    public class Reparent : MonoBehaviour
    {
        [HelpBox("Use this component carefully since it could introduce unforeseen bugs.", HelpBoxMessageType.Warning)]
        [SerializeField]
        // [CanBeNull]
        private Transform newParent;
        [SerializeField]
        private When when = When.OnStart;
        [SerializeField]
        private bool keepChildren;

        private void Start()
        {
            throw new NotImplementedException();
        }

        private enum When
        {
            OnAwake,
            OnStart
        }
    }
}