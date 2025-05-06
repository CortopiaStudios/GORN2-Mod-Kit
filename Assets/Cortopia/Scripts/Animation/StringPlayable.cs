// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Cortopia.Scripts.Animation
{
    [Serializable]
    public sealed class StringPlayable : PlayableAsset, ITimelineClipAsset
    {
        [SerializeField]
        private string value;

        public string DisplayName => this.value;

        public ClipCaps clipCaps => ClipCaps.None;

        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            return ScriptPlayable<StringPlayableBehavior>.Create(graph, new StringPlayableBehavior {Value = this.value});
        }
    }

    public class StringPlayableBehavior : PlayableBehaviour
    {
        public string Value;
    }
}