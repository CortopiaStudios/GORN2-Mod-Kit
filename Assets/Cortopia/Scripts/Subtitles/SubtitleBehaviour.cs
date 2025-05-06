// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine.Playables;

namespace Cortopia.Scripts.Subtitles
{
    public class SubtitleBehaviour : PlayableBehaviour
    {
        private SubtitleClip _clip;

        private string Text { get; set; }

        public override void ProcessFrame(Playable playable, FrameData info, object playerData)
        {
        }

        public override void OnBehaviourPause(Playable playable, FrameData info)
        {
        }

        public void Init(SubtitleClip clip)
        {
            _clip = clip;
        }

        public override void OnGraphStart(Playable playable)
        {
            SetText(_clip.text);
        }

        public override void OnGraphStop(Playable playable)
        {
        }

        private void SetText(string value)
        {
            Text = value;
        }
    }
}