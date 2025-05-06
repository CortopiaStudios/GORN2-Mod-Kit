// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.FX
{
    public class CollisionFX : GravesBehaviour
    {
        [SerializeField]
        private float maxVelocityLimit = 4;

        [SerializeField]
        private AssetReferenceGameObject defaultFX;

        [SerializeField]
        private CollisionFXConfig config;

        public AssetReferenceGameObject DefaultFX => this.defaultFX;

        private void Start()
        {
            throw new NotImplementedException();
        }

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}