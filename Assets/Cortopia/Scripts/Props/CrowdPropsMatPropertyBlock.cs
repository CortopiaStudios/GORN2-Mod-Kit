// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Props
{
    [RequireComponent(typeof(Renderer))]
    public class CrowdPropsMatPropertyBlock : MonoBehaviour
    {
        private static readonly float[] RandomFloats = {0, -0.25f, -0.5f, -0.75f};
        private static readonly int Color1 = Shader.PropertyToID("_Color");
        private static readonly int Offset = Shader.PropertyToID("_Offset");

        // Color exposed in the Inspector for custom tweaks
        [SerializeField]
        private Color color = Color.white;

        private void Start()
        {
            throw new NotImplementedException();
        }

        public void ApplyProperties()
        {
            throw new NotImplementedException();
        }
    }
}