// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveNullCheck : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<object> value;

        public Reactive<bool> IsNull => new();
        public Reactive<bool> IsNotNull => new();
    }
}