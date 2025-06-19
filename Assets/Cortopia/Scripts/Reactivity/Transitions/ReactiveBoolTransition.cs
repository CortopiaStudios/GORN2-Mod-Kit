// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Transitions
{
    public class ReactiveBoolTransition : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> doTransition;
        [SerializeField]
        private bool startValue;
        [SerializeField]
        private BoundValue<bool> fromValue;
        [SerializeField]
        private BoundValue<bool> toValue = new(true);

        [UsedImplicitly]
        public Reactive<bool> Output => new();

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}