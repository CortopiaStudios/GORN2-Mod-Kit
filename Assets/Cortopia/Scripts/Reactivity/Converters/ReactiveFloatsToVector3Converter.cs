// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveFloatsToVector3Converter : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> x;
        [SerializeField]
        private BoundValue<float> y;
        [SerializeField]
        private BoundValue<float> z;

        [UsedImplicitly]
        public Reactive<Vector3> Vector3 => new();
    }
}