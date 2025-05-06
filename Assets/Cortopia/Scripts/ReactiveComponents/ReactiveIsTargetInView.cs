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
    public class ReactiveIsTargetInView : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> forwardReference;
        [SerializeField]
        private BoundValue<Transform> target;
        [SerializeField]
        private BoundValue<float> viewAngle;
        [SerializeField]
        private BoundValue<bool> useYPlane;

        public Reactive<bool> IsInView => default;

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}