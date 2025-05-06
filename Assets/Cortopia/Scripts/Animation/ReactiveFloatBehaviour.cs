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
    public class ReactiveFloatTrackBehaviour : PlayableBehaviour
    {
        public float value;
        private WritableBoundValue<float> _writeTarget;

        public override void ProcessFrame(Playable playable, FrameData info, object playerData)
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                return;
            }
#endif
            this._writeTarget.SetValue(this.value);
        }

        public void Init(WritableBoundValue<float> writeTarget)
        {
            this._writeTarget = writeTarget;
        }
    }
}