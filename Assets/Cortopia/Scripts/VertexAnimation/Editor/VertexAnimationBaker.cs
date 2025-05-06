// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    public static class VertexAnimationBaker
    {
        public static BakedData Bake(this GameObject model, IEnumerable<AnimationClip> clips, bool applyRootMotion, int fps)
        {
            var bakedData = new BakedData
            {
                mesh = null,
                PositionMaps = new List<List<Vector3>>(),
                NormalMaps = new List<List<Vector3>>(),
                Animations = new Dictionary<string, (int, int)>(),
                minBounds = new Vector3(float.MaxValue, float.MaxValue, float.MaxValue),
                maxBounds = new Vector3(float.MinValue, float.MinValue, float.MinValue)
            };

            // Get the target mesh to calculate the animation info.
            Mesh mesh = model.GetComponent<SkinnedMeshRenderer>().sharedMesh;

            // Get the info for the biggest animation.
            foreach (AnimationClip clip in clips)
            {
                BakeClip(model, applyRootMotion, fps, clip, ref bakedData);
            }

            bakedData.mesh.bounds = new Bounds {max = bakedData.maxBounds, min = bakedData.minBounds};

            bakedData.mesh.uv3 = mesh.BakePositionUVs(bakedData);

            return bakedData;
        }

        private static void BakeClip(GameObject model, bool applyRootMotion, int fps, AnimationClip animationClip, ref BakedData bakedData)
        {
            if (bakedData.Animations.ContainsKey(animationClip.name))
            {
                return;
            }

            var animationInfo = new AnimationInfo(applyRootMotion, Mathf.FloorToInt(fps * animationClip.length));
            // Set the frames for this animation.

            BakedData bd = Bake(model, animationClip, animationInfo);
            bakedData.mesh = bd.mesh;
            bakedData.Animations.Add(animationClip.name, (bakedData.PositionMaps.Count, bakedData.PositionMaps.Count + bd.PositionMaps.Count - 1));
            bakedData.PositionMaps.AddRange(bd.PositionMaps);
            bakedData.NormalMaps.AddRange(bd.NormalMaps);
            bakedData.minBounds = Vector3.Min(bakedData.minBounds, bd.minBounds);
            bakedData.maxBounds = Vector3.Max(bakedData.maxBounds, bd.maxBounds);
        }

        public static BakedData Bake(this GameObject model, AnimationClip animationClip, AnimationInfo animationInfo)
        {
            var mesh = new Mesh {name = $"{model.name}"};

            // Set root motion options.
            if (model.TryGetComponent(out Animator animator))
            {
                animator.applyRootMotion = animationInfo.applyRootMotion;
            }

            // Bake mesh for a copy and to apply the new UV's to.
            var skinnedMeshRenderer = model.GetComponent<SkinnedMeshRenderer>();
            skinnedMeshRenderer.BakeMesh(mesh);
            mesh.RecalculateBounds();

            //mesh.uv3 = mesh.BakePositionUVs(animationInfo);

            BakedAnimation bakedAnimation = BakeAnimation(model, animationClip, animationInfo);

            var bakedData = new BakedData
            {
                mesh = mesh,
                PositionMaps = bakedAnimation.PositionMap,
                NormalMaps = bakedAnimation.NormalMap,
                minBounds = bakedAnimation.minBounds,
                maxBounds = bakedAnimation.maxBounds
            };

            mesh.bounds = new Bounds {max = bakedAnimation.maxBounds, min = bakedAnimation.minBounds};

            return bakedData;
        }

        public static BakedAnimation BakeAnimation(this GameObject model, AnimationClip animationClip, AnimationInfo animationInfo)
        {
            var positionMap = new List<List<Vector3>>();
            var normalMap = new List<List<Vector3>>();

            // Keep track of min/max bounds.
            var min = new Vector3(float.MaxValue, float.MaxValue, float.MaxValue);
            var max = new Vector3(float.MinValue, float.MinValue, float.MinValue);

            // Create instance to sample from.
            GameObject inst = Object.Instantiate(model);
            var skinnedMeshRenderer = inst.GetComponent<SkinnedMeshRenderer>();

            for (int f = 0; f < animationInfo.frames; f++)
            {
                animationClip.SampleAnimation(inst, animationClip.length / animationInfo.frames * f);

                var sampledMesh = new Mesh();
                skinnedMeshRenderer.BakeMesh(sampledMesh);

                var verts = new List<Vector3>();
                sampledMesh.GetVertices(verts);
                var normals = new List<Vector3>();
                sampledMesh.GetNormals(normals);

                var framePositions = new List<Vector3>();
                var frameNormals = new List<Vector3>();
                for (int v = 0; v < verts.Count; v++)
                {
                    min = Vector3.Min(min, verts[v]);
                    max = Vector3.Max(max, verts[v]);

                    framePositions.Add(verts[v]);
                    frameNormals.Add(normals[v]);
                }

                positionMap.Add(framePositions);
                normalMap.Add(frameNormals);
            }

            Object.DestroyImmediate(inst);

            return new BakedAnimation {PositionMap = positionMap, NormalMap = normalMap, minBounds = min, maxBounds = max};
        }

        public static Vector2[] BakePositionUVs(this Mesh mesh, BakedData bakedData)
        {
            int textureWidth = Mathf.NextPowerOfTwo(mesh.vertexCount);
            int rawFrameHeight = Mathf.CeilToInt((float) mesh.vertices.Length / textureWidth);
            int frameHeight = Mathf.NextPowerOfTwo(rawFrameHeight);
            int textureHeight = Mathf.NextPowerOfTwo(frameHeight * bakedData.PositionMaps.Count);

            var uv3 = new Vector2[mesh.vertexCount];

            float xOffset = 1.0f / textureWidth;
            float yOffset = 1.0f / textureHeight;

            float x = xOffset / 2.0f;
            float y = yOffset / 2.0f;

            for (int v = 0; v < uv3.Length; v++)
            {
                uv3[v] = new Vector2(x, y);

                x += xOffset;
                if (!(x >= 1.0f))
                {
                    continue;
                }

                x = xOffset / 2.0f;
                y += yOffset;
            }

            mesh.uv3 = uv3;

            return uv3;
        }

        [Serializable]
        public struct BakedData
        {
            public Mesh mesh;
            public Vector3 minBounds;
            public Vector3 maxBounds;
            public Dictionary<string, (int start, int end)> Animations;
            public List<List<Vector3>> NormalMaps;
            public List<List<Vector3>> PositionMaps;
        }

        [Serializable]
        public struct AnimationInfo
        {
            public bool applyRootMotion;
            public int frames;

            // Create animation info and calculate values.
            public AnimationInfo(bool applyRootMotion, int frames)
            {
                this.applyRootMotion = applyRootMotion;
                this.frames = frames;
            }
        }

        [Serializable]
        public struct BakedAnimation
        {
            public Vector3 minBounds;
            public Vector3 maxBounds;
            public List<List<Vector3>> NormalMap;
            public List<List<Vector3>> PositionMap;
        }
    }
}