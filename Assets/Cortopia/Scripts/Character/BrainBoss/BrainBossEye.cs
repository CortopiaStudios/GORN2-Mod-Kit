// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class BrainBossEye : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> neededImpact;
        [SerializeField]
        private BoundValue<float> combinedImpact = new(0);
        [SerializeField]
        private EyeSide eyeSide;
        [SerializeField]
        private Collider eyeCollider;
        [SerializeField]
        private Collider[] keepCollision;
        [SerializeField]
        private float destroyedEyeScale = 0.1f;
        [SerializeField]
        private Transform eyeBallGraphics;
        [SerializeField]
        private AssetReferenceGameObject eyeDestroyFX;
        [SerializeField]
        private float timeNoEye = 20.0f;
        [SerializeField]
        private float growBackTime = 3.0f;

        public EyeSide EyeSide => new();

        public Reactive<bool> IsActive => new();

        private void Start()
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

    public enum EyeSide
    {
        Right,
        Left
    }
}