// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using FMODUnity;
using UnityEngine;

namespace Cortopia.Scripts.Audio
{
    [CreateAssetMenu(menuName = "Cortopia/FMOD/Event Reference Object")]
    public class FMODEventReferenceObject : ScriptableObject
    {
        [SerializeField]
        private EventReference @event;
    }
}