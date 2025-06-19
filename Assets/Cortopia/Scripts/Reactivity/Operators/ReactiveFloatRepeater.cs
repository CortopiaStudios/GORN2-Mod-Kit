// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatRepeater : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> inputValue;
        [SerializeField]
        private UpdateMode updateMode;
        [SerializeField]
        private bool multiplyWithDeltaTime;

        [UsedImplicitly]
        public Reactive<float> RepeatedValue => new();

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }

        private enum UpdateMode
        {
            Update,
            FixedUpdate
        }
    }
}