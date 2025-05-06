// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveFloatToIntConverter : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> inputValue;

        [UsedImplicitly]
        public Reactive<int> Result => this.inputValue.Reactive.DistinctUntilChanged().Select(f => (int) f);
    }
}