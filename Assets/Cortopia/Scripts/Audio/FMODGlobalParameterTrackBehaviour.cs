// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine.Playables;

namespace Cortopia.Scripts.Audio
{
    [Serializable]
    public class FMODGlobalParameterTrackBehaviour : PlayableBehaviour
    {
        public float parameterValue;

        public override void ProcessFrame(Playable playable, FrameData info, object playerData)
        {
            throw new NotImplementedException();
        }

        public void Init(string globalParameterName, float minValue, float maxValue)
        {
        }
    }
}