// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents.Animator
{
    public class ReactiveAnimatorStateTrigger : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string animationStateName;

        public Reactive<IntegerCounter> StateTrigger => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public string GetName(string propertyName)
        {
            return propertyName == nameof(this.StateTrigger) ? $"Transition To {this.animationStateName}" : null;
        }
    }
}