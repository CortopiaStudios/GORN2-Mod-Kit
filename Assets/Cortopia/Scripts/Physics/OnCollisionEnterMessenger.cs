// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [DisallowMultipleComponent]
    public class OnCollisionEnterMessenger : MonoBehaviour
    {
        [SerializeField]
        private List<GameObject> listeners = new();

        public void RemoveListener(GameObject listener)
        {
            throw new NotImplementedException();
        }

        public void AddListener(GameObject listener)
        {
            throw new NotImplementedException();
        }
    }
}