// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using AOT;
using Cortopia.Scripts.Reactivity;
using FMOD;
using FMOD.Studio;
using FMODUnity;
using UnityEngine;

namespace Cortopia.Scripts.Audio
{
    public sealed class VoiceLinePlayer
    {
        [Serializable]
        public struct Parameter
        {
            public BoundValue<string> name;
            public BoundValue<float> value;
        }
    }
}