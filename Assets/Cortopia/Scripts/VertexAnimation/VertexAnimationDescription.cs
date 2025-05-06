// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation
{
    [Serializable]
    public struct AnimationStateSettings
    {
        public string state;
        public string value;
    }

    [Serializable]
    public struct VertexAnimationStateInfo
    {
        public AnimationStateSettings[] states;
        public VertexAnimationVariantInfo[] variants;
        public int poseIndex;
    }

    [Serializable]
    public struct VertexAnimationPoseTransitionInfo
    {
        public VertexAnimationTransitionInfo[] targetTransitions;
    }

    [Serializable]
    public struct VertexAnimationTransitionInfo
    {
        public int targetPoseIndex;
        public VertexAnimationVariantInfo[] variants;
    }

    [Serializable]
    public struct VertexAnimationVariantInfo
    {
        public VertexAnimationClipInfo clip;
        public float probability;
    }

    [Serializable]
    public struct VertexAnimationClipInfo
    {
        public string animationName;
        public int startFrame;
        public int endFrame;
        public float FrameCount => this.endFrame - this.startFrame;
    }

    [Serializable]
    public class VertexAnimationDescription : ScriptableObject
    {
        public VertexAnimationStateInfo[] states;
        public VertexAnimationPoseTransitionInfo[] poseTransitions;
        public float fps;
    }
}