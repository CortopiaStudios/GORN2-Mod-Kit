// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class PlayerHandGesture : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isTriggerPressed;
        [SerializeField]
        private BoundValue<bool> isGrabPressed;
        [SerializeField]
        private BoundValue<bool> isJoystickTouched;
        [SerializeField]
        private BoundValue<bool> isGrabbingObject;

        public Reactive<int> CurrentGesture => new();

        public Reactive<bool> AnyFistGesture => new();

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