// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class FloorDetector : GravesBehaviour
    {
        [SerializeField]
        private Vector3 extent;
        [SerializeField]
        private LayerMask searchForLayers;
        [SerializeField]
        private float maxDistance = 50;
        [SerializeField]
        private float originHeightOffset;

        public Reactive<float> FloorY => new();

        public Reactive<float> HitDistance => new();

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}