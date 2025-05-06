// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using FMOD.Studio;
using UnityEngine;

namespace Cortopia.Scripts.Audio
{
    public class FMODEventPlayer : MonoBehaviour
    {
        [SerializeField]
        private STOP_MODE stopMode;

        [SerializeField]
        private Parameter[] parameters;

        [SerializeField]
        [Tooltip("Should PlayFMODEvent stop previously playing FMOD instance?")]
        private bool stopPrevious;

        public Reactive<bool> IsPlaying => new();

        private void LateUpdate()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void PlayFMODEvent(FMODEventReferenceObject eventReference)
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private struct Parameter
        {
            public BoundValue<string> name;
            public BoundValue<float> value;
        }
    }
}