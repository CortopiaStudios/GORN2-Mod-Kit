// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.ComponentModel;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Cortopia.Scripts.Audio
{
    [DisplayName("FMOD/Global Parameter Track")]
    public class FMODGlobalParameterTrack : TrackAsset
    {
        [SerializeField]
        private string globalParameterName;
        [SerializeField]
        private float minValue;
        [SerializeField]
        private float maxValue;
        public FMODGlobalParameterTrackBehaviour template = new();

        public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
        {
            var scriptPlayable = ScriptPlayable<FMODGlobalParameterTrackBehaviour>.Create(graph, this.template, inputCount);
            scriptPlayable.GetBehaviour().Init(this.globalParameterName, this.minValue, this.maxValue);
            return scriptPlayable;
        }
    }
}
