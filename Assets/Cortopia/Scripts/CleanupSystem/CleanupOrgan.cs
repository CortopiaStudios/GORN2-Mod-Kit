// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.CleanupSystem
{
    public class CleanupOrgan : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> activate = new(false);

        [SerializeField]
        private CleanupQueue organCleanupQueue;

        [SerializeField]
        private BoundValue<bool> organGrabbed;

        [SerializeField]
        private Transform attachBody;

        [SerializeField]
        private float checkConnectedBodyInterval = 0.5f;

        private void FixedUpdate()
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
    }
}