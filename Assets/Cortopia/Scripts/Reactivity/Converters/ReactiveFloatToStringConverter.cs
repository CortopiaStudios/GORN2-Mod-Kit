// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveFloatToStringConverter : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> inputValue;

        [SerializeField]
        private string format = "f2";

        [UsedImplicitly]
        public Reactive<string> Result => this.inputValue.Reactive.DistinctUntilChanged().Select(x => x.ToString(this.format));
    }
}