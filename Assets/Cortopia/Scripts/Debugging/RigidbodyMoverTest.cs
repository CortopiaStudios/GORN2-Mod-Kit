// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Debugging
{
    public class RigidbodyMoverTest : MonoBehaviour
    {
        [SerializeField]
        private new Rigidbody rigidbody;

        [SerializeField]
        private Vector3 targetLocalPos;

        [SerializeField]
        private float speed;

        [SerializeField]
        private float delay;

        private void Start()
        {
            throw new NotImplementedException();
        }
    }
}