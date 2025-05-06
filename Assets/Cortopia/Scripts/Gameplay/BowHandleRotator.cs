// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class BowHandleRotator : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isBowStringGrabbed;

        [SerializeField]
        private BoundValue<IntegerCounter> onPoweredRelease;

        [SerializeField]
        private BoundValue<IntegerCounter> onNonPoweredRelease;

        [SerializeField]
        private BoundValue<bool> hasPreparedProjectile;

        [SerializeField]
        private Transform bowString;

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