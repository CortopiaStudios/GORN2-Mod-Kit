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
    public class ReactorTimeScale : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("The time scale value.")]
        private BoundValue<float> timeScale = new(1);
        [SerializeField]
        [Tooltip("Higher layers override lower layers, and any remaining equal layers are multiplied together.")]
        private BoundValue<int> layer = new(0);

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