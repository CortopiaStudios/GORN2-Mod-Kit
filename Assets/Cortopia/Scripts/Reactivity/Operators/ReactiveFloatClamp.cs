// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatClamp : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> source;
        [SerializeField]
        private BoundValue<float> minValue;
        [SerializeField]
        private BoundValue<float> maxValue;

        public Reactive<float> ClampedValue => new();
    }
}