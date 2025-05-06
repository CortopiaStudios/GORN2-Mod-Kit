// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    [Serializable]
    public struct AnimationPoseSettings
    {
        public string poseName;
        public AnimationLoopSettings[] loops;
        public AnimationTransitionSettings[] transitions;
    }

    [Serializable]
    public struct AnimationLoopSettings
    {
        public AnimationStateSettings[] states;
        public AnimationVariantSettings[] variants;
    }

    [Serializable]
    public struct AnimationTransitionSettings
    {
        public string targetPoseName;
        public AnimationVariantSettings[] variants;
    }

    [Serializable]
    public struct AnimationVariantSettings
    {
        public float probability;
        public AnimationClip clip;
    }
}