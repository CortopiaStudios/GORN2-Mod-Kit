// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveIntToModuloIntConverter : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> value;
        [SerializeField]
        private BoundValue<int> moduloValue;

        [UsedImplicitly]
        public Reactive<int> Result => this.value.Reactive.Combine(this.moduloValue.Reactive).Select((a, b) => a % b);
    }
}