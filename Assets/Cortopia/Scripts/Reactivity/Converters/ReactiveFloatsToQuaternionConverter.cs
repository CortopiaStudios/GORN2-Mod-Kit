// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveFloatsToQuaternionConverter : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> x;
        [SerializeField]
        private BoundValue<float> y;
        [SerializeField]
        private BoundValue<float> z;

        [UsedImplicitly]
        public Reactive<Quaternion> Quaternion => this.x.Reactive.Combine(this.y.Reactive, this.z.Reactive).Select(UnityEngine.Quaternion.Euler);
    }
}