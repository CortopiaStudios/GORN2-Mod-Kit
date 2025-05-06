// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Playables;

namespace Cortopia.Scripts.ReactiveComponents
{
    [RequireComponent(typeof(PlayableDirector))]
    public class ReactivePlayableDirector : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isPlaying;
        [SerializeField]
        private bool playOut;

        public Reactive<bool> IsPlaying => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }
    }
}