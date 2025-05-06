// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Playables;

namespace Cortopia.Scripts.Animation
{
    [Serializable]
    public class ReactiveBoolTrackBehaviour : PlayableBehaviour
    {
        public WritableBoundValue<bool> writeTarget;

        private bool[] _activeClips;

        public override void OnPlayableCreate(Playable playable)
        {
            this._activeClips = new bool[playable.GetInputCount()];
        }

        public override void ProcessFrame(Playable playable, FrameData info, object playerData)
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                return;
            }
#endif

            for (int i = 0; i < this._activeClips.Length; i++)
            {
                // If the clips weight equals zero that means our current frame is not on the clip.
                if (playable.GetInputWeight(i) <= 0f)
                {
                    this._activeClips[i] = false;
                    continue;
                }

                // Block event spamming.
                if (this._activeClips[i])
                {
                    return;
                }

                this._activeClips[i] = true;

                BoolPlayableBehavior behaviour = ((ScriptPlayable<BoolPlayableBehavior>) playable.GetInput(i)).GetBehaviour();
                this.writeTarget.SetValue(behaviour.Value);
            }
        }
    }
}