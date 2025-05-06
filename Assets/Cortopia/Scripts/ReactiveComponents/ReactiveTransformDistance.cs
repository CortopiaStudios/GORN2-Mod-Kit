// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveTransformDistance : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> transformA;
        [SerializeField]
        private BoundValue<Transform> transformB;
        [SerializeField]
        private BoundValue<float> maxDistance;

        public Reactive<bool> IsClose => default;

        public Reactive<float> CurrentDistance => default;

        private void Update()
        {
            throw new NotImplementedException();
        }
    }
}