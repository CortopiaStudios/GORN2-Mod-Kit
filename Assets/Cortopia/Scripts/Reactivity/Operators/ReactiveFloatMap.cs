// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatMap : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> source;
        [SerializeField]
        private BoundValue<float> currentMinValue;
        [SerializeField]
        private BoundValue<float> currentMaxValue;
        [SerializeField]
        private BoundValue<float> newMinValue;
        [SerializeField]
        private BoundValue<float> newMaxValue;

        public Reactive<float> MappedValue =>
            this.source.Reactive.Combine(this.currentMinValue.Reactive.Combine(this.currentMaxValue.Reactive), this.newMinValue.Reactive.Combine(this.newMaxValue.Reactive))
                .Select(x => Mathf.LerpUnclamped(x.Item3.Item1, x.Item3.Item2, Mathf.InverseLerp(x.Item2.Item1, x.Item2.Item2, x.Item1)));
    }
}