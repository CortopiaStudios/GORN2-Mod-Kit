// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Debugging
{
    public class DebugShooter : MonoBehaviour
    {
        [SerializeField]
        private float projectileLifetime = 3;
        [SerializeField]
        private Item[] items;

        private void Update()
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private struct Item
        {
            public KeyCode shootKey;
            public Rigidbody prefab;
            public float speed;
        }
    }
}