// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.ComponentModel;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Cortopia.Scripts.Animation
{
    [TrackColor(0f, 0.4f, 0.8f)]
    [TrackClipType(typeof(BoolPlayable))]
    [DisplayName("Reactive/Reactive Bool Track")]
    public class ReactiveBoolTrack : TrackAsset
    {
        [SerializeField]
        private WritableBoundValue<bool> writeTarget;

        private readonly ReactiveBoolTrackBehaviour _template = new();

        public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
        {
            foreach (TimelineClip clip in this.GetClips())
            {
                if (clip.asset is BoolPlayable boolPlayable)
                {
                    clip.displayName = boolPlayable.DisplayName.ToString();
                }
            }

            this._template.writeTarget = this.writeTarget;
            return ScriptPlayable<ReactiveBoolTrackBehaviour>.Create(graph, this._template, inputCount);
        }
    }
}