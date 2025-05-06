// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public class PreciseForce : MonoBehaviour
    {
        [HelpBox("This script will apply a force to a Rigidbody along a vector.")]
        [Space]
        [SerializeField]
        private BoundValue<bool> isActive;

        [SerializeField]
        private BoundValue<IntegerCounter> trigger;

        [Tooltip("The direction to push in, in local space.")]
        [SerializeField]
        private BoundValue<Vector3> localDirection;

        [SerializeField]
        private new BoundValue<Rigidbody> rigidbody;

        [SerializeField]
        private BoundValue<float> force = new(10.0f);

        [SerializeField]
        private BoundValue<ForceMode> forceMode = new(ForceMode.Impulse);

        private void OnEnable()
        {
            throw new NotImplementedException();
        }
    }
}