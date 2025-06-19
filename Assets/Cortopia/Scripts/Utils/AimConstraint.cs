// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    public class AimConstraint : MonoBehaviour
    {
        [HelpBox("Aims the constrained object towards a target object. If several objects with a AimConstraint or TwoBoneConstraint component are childed " +
                 "directly under one parent object, they update in the hierarchy order. This can be utilized when rotating multiple bones in a rig towards a target")]
        [SerializeField]
        [Range(0.0f, 1.0f)]
        private float weight;
        [SerializeField]
        private Transform constrainedObject;
        [SerializeField]
        private AxisDirection aimAxis;
        [SerializeField]
        private Transform targetObject;
        [SerializeField]
        [Tooltip("The offset rotation is applied as an additional rotation after the target rotation has been computed")]
        private BoundValue<Vector3> offset = new();
        [SerializeField]
        [Range(0f, 180f)]
        private float rotationLimit;
        
        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }

        private enum AxisDirection
        {
            XPositive,
            XNegative,
            YPositive,
            YNegative,
            ZPositive,
            ZNegative
        }
    }
}