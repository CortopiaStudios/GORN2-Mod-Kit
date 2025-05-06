// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveMapFloat : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> value;
        [SerializeField]
        private BoundValue<float> min1;
        [SerializeField]
        private BoundValue<float> max1;
        [SerializeField]
        private BoundValue<float> min2;
        [SerializeField]
        private BoundValue<float> max2;

        public Reactive<float> Result => default;
    }
}