// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    public static class VertexAnimationMaterial
    {
        private static readonly int PositionMap = Shader.PropertyToID("_VAT_positions");
        private static readonly int NormalMap = Shader.PropertyToID("_VAT_normals");
        private static readonly int LineHeight = Shader.PropertyToID("_LineHeight");
        private static readonly int Diffuse = Shader.PropertyToID("_Diffuse");
        private static readonly int Tiling = Shader.PropertyToID("_Tiling");
        private static readonly int AnimationFps = Shader.PropertyToID("_AnimationFps");

        public static Material Create(string name, Shader shader)
        {
            var material = new Material(shader) {name = name, enableInstancing = true};

            return material;
        }

        public static Material Create(
            string name, Shader shader, Texture diffuse, Texture2D positionMap, Texture2D normalMap, int totalFrames, float animationFps,
            Material copyPropertiesFromMaterial = null)
        {
            Material material = Create(name, shader);

            material.Update(name, shader, diffuse, positionMap, normalMap, totalFrames, animationFps, copyPropertiesFromMaterial);

            return material;
        }

        public static void Update(
            this Material material, string name, Shader shader, Texture diffuse, Texture2D positionMap, Texture2D normalMap, int vertices, float animationFps,
            Material copyPropertiesFromMaterial = null)
        {
            material.name = name;

            if (material.shader != shader)
            {
                material.shader = shader;
            }

            if (copyPropertiesFromMaterial)
            {
                material.CopyMatchingPropertiesFromMaterial(copyPropertiesFromMaterial);
            }

            int rawFrameHeight = Mathf.CeilToInt((float) vertices / positionMap.width);
            float texLineHeight = (float) Mathf.NextPowerOfTwo(rawFrameHeight) / positionMap.height;

            material.SetTexture(Diffuse, diffuse);
            material.SetTexture(PositionMap, positionMap);
            material.SetTexture(NormalMap, normalMap);
            material.SetFloat(LineHeight, texLineHeight);
            material.SetFloat(AnimationFps, animationFps);
        }

        public static void UpdateUVTiling(this Material material, Vector2 uvTiling)
        {
            material.SetVector(Tiling, uvTiling);
        }
    }
}