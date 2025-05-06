// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    public enum ForceFieldPushMode
    {
        UseLocalDirection,
        UseTargetPosition
    }

    public class ForceField : GravesBehaviour
    {
        [SerializeField]
        private bool triggerOnlyOnEnter;
        [SerializeField]
        private BoundValue<GameObject> targetObject;
        [SerializeField]
        private Transform destinationPoint;
        [SerializeField]
        private Vector3 localDirection = Vector3.up;
        [SerializeField]
        private LayerMask layerMask;
        [SerializeField]
        private ForceFieldPushMode mode;
        [SerializeField]
        private BoundValue<float> force = new(10.0f);
        [SerializeField]
        private ForceMode forceMode;
        [SerializeField]
        private UnityEvent<Rigidbody> onTrigger;

        public Reactive<bool> IsActive => default;

        private void Update()
        {
            throw new NotImplementedException();
        }

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}