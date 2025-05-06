// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.CleanupSystem
{
    public class CleanupWeapon : MonoBehaviour
    {
        [SerializeField]
        private bool cleanupAfterFirstGrab = true;

        [SerializeField]
        private CleanupQueue weaponCleanupQueue;

        [SerializeField]
        private List<BoundValue<bool>> weaponHandlesIsGrabbed;

        [SerializeField]
        private List<BoundValue<GameObject>> connectedObjects;

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