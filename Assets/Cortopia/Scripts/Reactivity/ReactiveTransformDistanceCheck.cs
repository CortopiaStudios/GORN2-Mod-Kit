// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveTransformDistanceCheck : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> transformA;
        [SerializeField]
        private BoundValue<Transform> transformB;
        [SerializeField]
        private float maxDistance;

        [UsedImplicitly]
        public Reactive<bool> IsClose => new();

        [UsedImplicitly]
        public Reactive<float> CurrentDistance => new();

        private void Update()
        {
        }
    }
}