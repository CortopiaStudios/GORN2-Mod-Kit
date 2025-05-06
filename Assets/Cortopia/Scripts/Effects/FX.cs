// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Oculus.Interaction;
using UnityEngine;

namespace Cortopia.Scripts.Effects
{
    public class FX : MonoBehaviour
    {
        [SerializeField]
        private bool destroyWhenNotPlaying = true;

        [Header("VFX")]
        [SerializeField]
        private float vfxIntensityScale = 10;
        [SerializeField]
        private List<ParticleSystemAndLimit> particleSystems;

        [Header("SFX")]
        [SerializeField]
        private float sfxIntensityScale = 10;
        [SerializeField]
        private string sfxParameterName = "Intensity";

        [Header("Haptics")]
        [SerializeField]
        private float hapticsIntensityScale = 10;
        [Tooltip("If the FX is spawned in, this can be left null, as the spawner will set the player.")]
        [SerializeField]
        // [CanBeNull]
        [Interface(typeof(IHapticsPlayer))]
        private MonoBehaviour hapticsPlayer;
        [SerializeField]
        private List<HapticsAndLimit> hapticsSequences;

        private void LateUpdate()
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

        public void SetIntensity(float value01)
        {
            throw new NotImplementedException();
        }

        [Serializable]
        public class ParticleSystemAndLimit
        {
            public float minRenderDistance;
            public float maxRenderDistance = Mathf.Infinity;
            public float intensity;
            // [CanBeNull]
            public ParticleSystem particleSystem;
        }

        [Serializable]
        public struct HapticsAndLimit
        {
            public float intensity;
            public List<HapticClip> sequence;
        }
    }
}