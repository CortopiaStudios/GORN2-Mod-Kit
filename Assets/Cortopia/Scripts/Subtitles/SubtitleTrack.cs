// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.ComponentModel;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Cortopia.Scripts.Subtitles
{
    [TrackBindingType(typeof(Transform))]
    [TrackClipType(typeof(SubtitleClip))]
    [DisplayName("Cortopia/Subtitle Track")]
    public class SubtitleTrack : TrackAsset
    {
        public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
        {
            var director = graph.GetResolver() as PlayableDirector;
            var binding = director!.GetGenericBinding(this) as Transform;
            foreach (TimelineClip clip in this.GetClips())
            {
                var playableAsset = clip.asset as SubtitleClip;
                if (playableAsset != null)
                {
                    playableAsset.Binding = binding;
                }
            }

            return base.CreateTrackMixer(graph, go, inputCount);
        }
    }
}