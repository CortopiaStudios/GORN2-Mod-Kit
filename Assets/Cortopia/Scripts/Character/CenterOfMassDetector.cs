// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class CenterOfMassDetector : MonoBehaviour
    {
        [SerializeField]
        private float heightOffset;

        public Reactive<float> Tilt => new();
        public Reactive<Vector3> TiltDirection => new();
        public Reactive<Vector3> CenterOfMass => new();

        private void Start()
        {
            throw new NotImplementedException();
        }

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

        public void UpdateRigidBodies()
        {
            throw new NotImplementedException();
        }
    }
}