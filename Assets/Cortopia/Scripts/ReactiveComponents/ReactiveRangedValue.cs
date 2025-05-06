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
    public class ReactiveRangedValue<T> : MonoBehaviour
    {
        [SerializeField]
        private T minValue;
        [SerializeField]
        private T maxValue;
        [SerializeField]
        private ReactiveSource<T> unclampedValue = new(default(T));

        public Reactive<T> ClampedValue => default;

        public ReactiveSource<T> UnclampedValue => this.unclampedValue;

        public void SetMaxValue(T newMaxValue)
        {
            throw new NotImplementedException();
        }
    }
}