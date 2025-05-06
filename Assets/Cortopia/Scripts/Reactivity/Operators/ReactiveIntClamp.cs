// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveIntClamp : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> source;
        [SerializeField]
        private BoundValue<int> minValue;
        [SerializeField]
        private BoundValue<int> maxValue;

        public Reactive<int> ClampedValue =>
            this.source.Reactive.Combine(this.minValue.Reactive, this.maxValue.Reactive).Select(x => Mathf.Clamp(x.Item1, x.Item2, x.Item3));
    }
}