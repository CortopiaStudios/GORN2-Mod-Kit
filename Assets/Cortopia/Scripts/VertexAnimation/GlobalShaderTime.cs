// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation
{
    public class GlobalShaderTime : MonoBehaviour
    {
        private static readonly int TimeProperty = Shader.PropertyToID("_CurTime");

        private void Update()
        {
            throw new NotImplementedException();
        }
    }
}