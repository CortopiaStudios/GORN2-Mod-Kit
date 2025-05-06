// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.CleanupSystem;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Gameplay
{
    public class Life : MonoBehaviour
    {
        [SerializeField]
        private ReactiveSource<bool> isAlive = new(true);
        [SerializeField]
        private bool cleanupEnabled = true;
        [SerializeField]
        private UnityEvent<DamageEvent> onKill;

        public Reactive<bool> IsAlive => default;

        public bool CleanupEnabled => default;

        public GameObject GameObject => default;

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

        public void SetCleanupEnabled(bool value)
        {
            throw new NotImplementedException();
        }

        public void Destroy()
        {
            throw new NotImplementedException();
        }

        public void DelayedDestroy(float time)
        {
            throw new NotImplementedException();
        }

        public void Kill()
        {
            throw new NotImplementedException();
        }

        public void SetCleanupQueue(CleanupQueue cleanupQueue)
        {
            throw new NotImplementedException();
        }
    }
}