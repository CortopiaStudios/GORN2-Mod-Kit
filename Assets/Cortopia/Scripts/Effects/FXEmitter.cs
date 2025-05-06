// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Effects
{
    public class FXEmitter : MonoBehaviour
    {
        [Tooltip("This will merely ensure that the trigger is being listened to.")]
        [SerializeField]
        private BoundValue<bool> isActive = new(false);

        [Tooltip("The event that triggers the FX. Note that isActive has to be true for this to apply.")]
        [SerializeField]
        private BoundValue<IntegerCounter> trigger = new(default(IntegerCounter));

        [Tooltip("If this is set to true the FX will emitted whenever its active.")]
        [SerializeField]
        private bool autoTrigger;

        // [CanBeNull]
        [SerializeField]
        private WeaponHapticsController hapticsController;

        [SerializeField]
        private float intensity = 1.0f;

        [SerializeField]
        private AirFixedHitFXSpawner fx;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        [ContextMenu("Play FX")]
        public void PlayFX()
        {
            this.PlayFXWithIntensity(this.intensity);
        }

        public void PlayFXAtPose(Pose pose)
        {
            throw new NotImplementedException();
        }

        public void PlayFXWithIntensity(float intensityValue)
        {
            throw new NotImplementedException();
        }

        [ContextMenu("Stop FX")]
        public void StopFX()
        {
            throw new NotImplementedException();
        }
    }
}