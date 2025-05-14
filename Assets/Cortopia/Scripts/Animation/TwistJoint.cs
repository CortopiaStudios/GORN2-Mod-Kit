// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public sealed class TwistJoint : MonoBehaviour
    {
        [SerializeField]
        private Transform twistReference;
        [SerializeField]
        [Range(0f, 1f)]
        private float twistAmount;
        [SerializeField]
        private TwistAxis twistAxis;
        [SerializeField]
        public float twistAdjustment;

        private void LateUpdate()
        {
        }

        private enum TwistAxis
        {
            X,
            Y,
            Z
        }
    }
}