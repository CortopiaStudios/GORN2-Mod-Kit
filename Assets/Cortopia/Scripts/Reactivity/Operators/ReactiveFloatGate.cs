// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatGate : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> input;
        [SerializeField]
        private BoundValue<float> threshold;
        [SerializeField]
        private BoundValue<float> @return;

        public Reactive<float> Input => new();
        public Reactive<float> Threshold => new();
        public Reactive<float> Return => new();
        public Reactive<bool> Output => new();

        private void OnEnable()
        {
          
        }

        private void OnDisable()
        {
        }
    }
}