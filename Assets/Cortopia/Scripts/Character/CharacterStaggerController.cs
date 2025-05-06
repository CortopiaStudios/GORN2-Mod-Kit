// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Animation;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class CharacterStaggerController : MonoBehaviour
    {
        [SerializeField]
        private PhysicsRootMotion physicsRootMotion;
        [Space]
        [SerializeField]
        [Tooltip("How fast should the stagger value increase.")]
        private float acceleration = 10;
        [SerializeField]
        [Tooltip("How fast should the stagger value decrease.")]
        private float deceleration = 10;
        [SerializeField]
        [Tooltip("At what velocity vs root animation velocity should the staggering start.")]
        private float errorVelocityThreshold = 1.4f;
        [SerializeField]
        [Tooltip("While staggering, at what velocity should the staggering stop.")]
        private float velocityReturn = 0.2f;
        [SerializeField]
        [Tooltip("The max stagger value error so it doesn't add up too much.")]
        private float clampError = 5;

        public Reactive<bool> IsStaggering => new();

        public Reactive<float> Stagger => new();

        public Reactive<bool> ShouldFall => new();

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }

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