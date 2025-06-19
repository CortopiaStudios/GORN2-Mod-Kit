// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Core;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Utils
{
    public class SingleSpawnerSequence : MonoBehaviour
    {
        [HelpBox(
            "Enable Single Spawner components in a sequence to avoid making them spawn on the same frame. Make sure to disable the single spawners from start when using this component.")]
        [SerializeField]
        private SingleSpawner[] singleSpawners;
        [SerializeField]
        private UnityEvent onCompleted;

        private void Start()
        {
        }
    }
}