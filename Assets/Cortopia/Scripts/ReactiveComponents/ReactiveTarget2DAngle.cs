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
    public class ReactiveTarget2DAngle : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> reference;
        [SerializeField]
        private BoundValue<Transform> target;
        [SerializeField]
        private BoundValue<Vector3> axis = new(Vector3.up);

        public Reactive<float> Angle => default;

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}