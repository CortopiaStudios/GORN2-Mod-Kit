// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Gameplay;
using Cortopia.Scripts.Gore.Slicing.Internal;
using Cortopia.Scripts.Painting;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Gore.Slicing.FX
{
    [Serializable]
    public struct PaintParticleArgs
    {
        public float particleRadius;
        public float particleStrength;
        public float particleHardness;
        public Color particleColor;

        public PaintParticleArgs(float particleRadius, float particleStrength, float particleHardness, Color particleColor)
        {
            this.particleRadius = particleRadius;
            this.particleStrength = particleStrength;
            this.particleHardness = particleHardness;
            this.particleColor = particleColor;
        }
    }

    [Serializable]
    public struct PaintEdgesArgs
    {
        [Tooltip("The index step between cap edge vertices that will be used to position particles")]
        public int vertexIndexStep;
        [Tooltip("Multiplier for the cap edge vertex count to get particle count to paint, percentage")]
        public float fillFactor;
        [Tooltip("Random multiplier for particle radius, percentage")]
        public float randomSizeFactor;
        [Tooltip("Random multiplier for vertex distance offset to cap center, percentage")]
        public float randomCenterDistanceFactor;
        [Tooltip("Random multiplier for vertex height offset, meters")]
        public float randomHeight;

        public PaintEdgesArgs(int vertexIndexStep, float fillFactor, float randomSizeFactor, float randomCenterDistanceFactor, float randomHeight)
        {
            this.vertexIndexStep = vertexIndexStep;
            this.fillFactor = fillFactor;
            this.randomSizeFactor = randomSizeFactor;
            this.randomCenterDistanceFactor = randomCenterDistanceFactor;
            this.randomHeight = randomHeight;
        }
    }

    [RequireComponent(typeof(Slicable))]
    public class SlicableFX : MonoBehaviour
    {
        [SerializeField]
        private AssetReferenceGameObject mainLimbEffect;
        [SerializeField]
        private AssetReferenceGameObject detachedLimbEffect;
        [SerializeField]
        private PaintEdgesArgs paintEdgesArgs = new(1, 1.8f, 0.0f, 0.0f, 0.0f);
        [SerializeField]
        private PaintParticleArgs paintParticleArgs = new(0.05f, 2.2f, 1.0f, Color.red);

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void CopyVariables(SlicableFX source)
        {
            this.mainLimbEffect = source.mainLimbEffect;
            this.detachedLimbEffect = source.detachedLimbEffect;
            this.paintEdgesArgs = source.paintEdgesArgs;
            this.paintParticleArgs = source.paintParticleArgs;
        }
    }
}