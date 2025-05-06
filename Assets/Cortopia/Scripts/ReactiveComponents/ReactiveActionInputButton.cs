// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveActionInputButton : MonoBehaviour
    {
        [SerializeField]
        // ReSharper disable once NotAccessedField.Local
        private InputActionProperty inputProperty;

        public Reactive<bool> IsPressed => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }
    }
}