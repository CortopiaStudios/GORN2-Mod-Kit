// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Audio
{
    public class UnityEventList : MonoBehaviour
    {
        [SerializeField]
        private List<UnityEvent> events;

        [UsedImplicitly]
        public void InvokeEvent(int n)
        {
            throw new NotImplementedException();
        }
    }
}