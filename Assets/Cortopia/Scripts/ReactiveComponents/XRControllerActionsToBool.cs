// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Interaction;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class XRControllerActionsToBool : MonoBehaviour
    {
        [SerializeField]
        private CrossPlatformXRController controller;
        [SerializeField]
        private InputActionProperty primaryButton;
        [SerializeField]
        private InputActionProperty secondaryButton;

        public Reactive<bool> ActivateIsPressed => default;

        public Reactive<bool> SelectIsPressed => default;

        public Reactive<bool> PrimaryButtonIsPressed => default;

        public Reactive<bool> SecondaryButtonIsPressed => default;

        private void Update()
        {
            throw new NotImplementedException();
        }
    }
}