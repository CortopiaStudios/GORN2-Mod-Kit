// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using FMODUnity;
using UnityEngine;
using UnityEngine.Serialization;

namespace Cortopia.Scripts.Audio
{
    public sealed class Voice : MonoBehaviour
    {
        [SerializeField]
        private EventReference eventReference;
        [FormerlySerializedAs("dialogID")]
        [SerializeField]
        private BoundValue<string> dialogueID;
        [FormerlySerializedAs("inGameMenuIsOpen")]
        [SerializeField]
        private BoundValue<bool> pause;
        [SerializeField]
        private VoiceLinePlayer.Parameter[] parameters;

        public Reactive<bool> IsPlaying => new();

        public Reactive<string> CurrentEventID => new();

        public float ClipLength => new();

        private void Update()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void Pause(bool isPaused)
        {
            throw new NotImplementedException();
        }

        public void Stop()
        {
            throw new NotImplementedException();
        }
    }
}