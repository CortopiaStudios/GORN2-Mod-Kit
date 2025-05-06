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
    public class ReactiveAnimatorStateCheck : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string animationStateName;

        public Reactive<bool> IsStateMatch => default;

        public Reactive<bool> IsStateNotMatch => default;

        public Reactive<bool> IsStateTagMatch => default;

        public Reactive<bool> IsStateTagNotMatch => default;

        public string AnimationStateName => this.animationStateName;

        public string GetName(string propertyName)
        {
            return propertyName switch
            {
                nameof(this.IsStateMatch) => $"State is {this.AnimationStateName}",
                nameof(this.IsStateNotMatch) => $"State is not {this.AnimationStateName}",
                nameof(this.IsStateTagMatch) => $"State tag is {this.AnimationStateName}",
                nameof(this.IsStateTagNotMatch) => $"State tag is not {this.AnimationStateName}",
                _ => null
            };
        }
    }
}