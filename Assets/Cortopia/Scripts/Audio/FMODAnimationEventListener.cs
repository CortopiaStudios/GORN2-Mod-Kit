// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using FMOD.Studio;
using UnityEngine;
using UnityEngine.Events;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Audio
{
    [RequireComponent(typeof(Animator))]
    public class FMODAnimationEventListener : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> attachGameObject;
        [SerializeField]
        private STOP_MODE stopMode;
        [Space]
        [SerializeField]
        private UnityEvent<FMODEventReferenceObject> onEvent;

        public Reactive<(IntegerCounter, FMODEventReferenceObject)> FMODEvents => new();

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void play_audio(Object obj)
        {
            throw new NotImplementedException();
        }
    }
}