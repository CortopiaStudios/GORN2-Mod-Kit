// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    public class TwoBoneConstraint : MonoBehaviour
    {
        [HelpBox(
            "This component rotates the root and mid bones towards the target while preserving the rotation of the tip bone. If several objects with a AimConstraint or TwoBoneConstraint " +
            "component are childed directly under one parent object, they update in the hierarchy order. This can be utilized when rotating multiple bones in a rig towards a target")]
        [SerializeField]
        private Transform root;
        [SerializeField]
        private Transform mid;
        [SerializeField]
        private Transform tip;
        [SerializeField]
        private Transform target;
        [SerializeField]
        private Vector3 rootBendAxis;
    }
}