// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.CleanupSystem
{
    public class CleanupGameObject : MonoBehaviour
    {
        [SerializeField]
        // [CanBeNull]
        private CleanupQueue queue;

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

        public void SetCleanupQueue(CleanupQueue cleanupQueue)
        {
            throw new NotImplementedException();
        }
    }
}