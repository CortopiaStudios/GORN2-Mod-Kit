// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Animation.PhonemeSystem
{
    public class PhonemeHandler : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Has to be either of type Voice or FMODEventPlayer.")]
        private Component voicePlayer;

        [Space]
        [SerializeField]
        private BoundValue<bool> isActive;
        [SerializeField]
        private BoundValue<Animator> animator;
        [SerializeField]
        private BoundValue<float> normalizedTransitionDuration;
        [SerializeField]
        private float phonemeTimingCalibration = -0.6f;
        [Space]
        [Tooltip("The name of the default state in the Animator layer - the one to return to when no phoneme is active.")]
        [SerializeField]
        private string idleStateName = "Idle";
        [Tooltip("The name of the Animator layer in which the phoneme states are placed.")]
        [SerializeField]
        private string layerName = "Lipsync";

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
    }
}