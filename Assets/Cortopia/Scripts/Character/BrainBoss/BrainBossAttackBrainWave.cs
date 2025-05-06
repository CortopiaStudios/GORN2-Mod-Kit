// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class BrainBossAttackBrainWave : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> brainWaveTrigger;
        [SerializeField]
        private BrainBossEye[] eyes;
        [SerializeField]
        private string tagEffectSensitiveObjects;
        [SerializeField]
        private float effectTime;
        [SerializeField]
        private float startEffectDelay;
        [Space]
        [SerializeField]
        private WritableBoundValue<bool> switchHandsUpDown;
        [SerializeField]
        private WritableBoundValue<bool> switchHandsMoveTurn;

        public Reactive<bool> RightBrainWaveActive => new();

        public Reactive<bool> LeftBrainWaveActive => new();

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

        private void OnDestroy()
        {
            throw new NotImplementedException();
        }
    }
}