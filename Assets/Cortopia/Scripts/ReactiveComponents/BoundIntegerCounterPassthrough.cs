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
    public class BoundIntegerCounterPassthrough : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<IntegerCounter> sourceValue;
        [Tooltip("When sourceCounter increments, these IntegerCounters will be incremented as well - but their internal counter values will remain separated.")]
        [SerializeField]
        private WritableBoundValue<IntegerCounter>[] targetValues;

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