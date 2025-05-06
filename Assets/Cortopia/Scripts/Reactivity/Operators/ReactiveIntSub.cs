// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveIntSub : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> valueA;
        [SerializeField]
        private BoundValue<int> valueB;

        [UsedImplicitly]
        public Reactive<int> Result => this.valueA.Reactive.Combine(this.valueB.Reactive).Select((a, b) => a - b);
    }
}