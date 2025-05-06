// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveBoolToVector3Converter : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> condition;
        [Space]
        [SerializeField]
        private BoundValue<Vector3> falseValue;
        [SerializeField]
        private BoundValue<Vector3> trueValue;

        public Reactive<Vector3> Result => default;
    }
}