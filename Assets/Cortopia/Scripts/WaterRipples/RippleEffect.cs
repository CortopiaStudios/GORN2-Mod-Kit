// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.WaterRipples
{
    [RequireComponent(typeof(Renderer))]
    public class RippleEffect : MonoBehaviour
    {
        private static readonly int RippleTex = Shader.PropertyToID("_RippleTex");
        private static readonly int ObjectsRT = Shader.PropertyToID("_ObjectsRT");
        private static readonly int CurrentRT = Shader.PropertyToID("_CurrentRT");
        private static readonly int PrevRT = Shader.PropertyToID("_PrevRT");

        public int textureSize = 512;
        public RenderTexture objectsRT;
        public Shader rippleShader;
        public Shader addShader;

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void Update()
        {
            throw new NotImplementedException();
        }
    }
}