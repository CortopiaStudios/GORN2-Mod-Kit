// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.Playables;

namespace Cortopia.Scripts.Subtitles
{
    public class SubtitleClip : PlayableAsset
    {
        public Sprite speakerSprite;
        [Space]
        public string text;

        public Transform Binding { get; set; }

        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            var playable = ScriptPlayable<SubtitleBehaviour>.Create(graph);
            playable.GetBehaviour().Init(this);
            return playable;
        }
    }
}