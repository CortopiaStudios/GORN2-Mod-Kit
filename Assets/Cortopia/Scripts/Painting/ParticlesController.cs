// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Painting
{
    public class ParticlesController : MonoBehaviour
    {
        public Color paintColor;

        public float minRadius = 0.05f;
        public float maxRadius = 0.2f;
        public float strength = 1;
        public float hardness = 1;

        private void Start()
        {
            throw new NotImplementedException();
        }
    }
}