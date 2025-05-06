// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveJointDrive : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> positionSpring;
        [SerializeField]
        private BoundValue<float> positionDamper;
        [SerializeField]
        private BoundValue<float> maximumForce = new(Mathf.Infinity);
        [SerializeField]
        private BoundValue<bool> useAcceleration = new(true);

        public Reactive<JointDrive> JointDrive => default;
    }
}