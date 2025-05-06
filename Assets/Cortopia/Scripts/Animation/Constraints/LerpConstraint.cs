// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Animation.Constraints
{
    public class LerpConstraint : MonoBehaviour
    {
        [Header("Constrained Transforms")]
        [SerializeField]
        private Transform parentJoint;
        [SerializeField]
        private Transform childJoint;
        [Header("Position Settings")]
        [Tooltip("Should move")]
        [SerializeField]
        private bool constrainPosition;
        [Tooltip("Keep the initial position offset between the parent joint and the child joint")]
        [SerializeField]
        private bool keepPositionOffset;
        [Tooltip("Smooth movement")]
        [SerializeField]
        private bool lerpPosition;
        [Tooltip("Smooth movement speed")]
        [SerializeField]
        private float positionLerpStrength;
        [Header("Rotation Settings")]
        [Tooltip("Should rotate")]
        [SerializeField]
        private bool constrainRotation;
        [Tooltip("Keep the initial rotation offset between the parent joint and the child joint")]
        [SerializeField]
        private bool keepRotationOffset;
        [Tooltip("Smooth rotation")]
        [SerializeField]
        private bool lerpRotation;
        [Tooltip("Lock the horizontal rotation")]
        [SerializeField]
        private bool lockHorizontalRotation;
        [Tooltip("Smooth rotation speed")]
        [SerializeField]
        private float rotationLerpStrength;
        [Header("General Settings")]
        [Tooltip("Initiate values on start")]
        [SerializeField]
        private bool activateConstraintOnStart;

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void Update()
        {
            throw new NotImplementedException();
        }

        public void ActivateConstraint(Transform newParentJoint)
        {
            throw new NotImplementedException();
        }

        public void ActivateConstraint()
        {
            throw new NotImplementedException();
        }

        public void DeactivateConstraint()
        {
            throw new NotImplementedException();
        }
    }
}