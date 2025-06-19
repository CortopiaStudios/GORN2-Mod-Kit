// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.InputSystem;

namespace Cortopia.Scripts.Reactivity.Input
{
    public class ReactiveInputActionFloat : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        [Tooltip("The Input System Action that will be used to read data from the hand controller.")]
        private InputActionProperty inputAction = new(new InputAction("Input action"));

        public Reactive<float> CurrentInput => new();

        private void Update()
        {
        }
        
        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }
    }
}