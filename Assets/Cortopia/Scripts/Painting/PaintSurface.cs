// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Physics;
using UnityEngine;

namespace Cortopia.Scripts.Painting
{
    [RequireComponent(typeof(Renderer))]
    public class PaintSurface : GravesBehaviour
    {
        private static readonly int MaskTextureID = Shader.PropertyToID("_MaskTexture");

        [SerializeField]
        private int textureSize = 128;
        [SerializeField]
        private bool cleanBlood;
        [SerializeField]
        private bool autoInitialize = true;
        [SerializeField]
        private float extendsIslandOffset = 1;
        [SerializeField]
        private bool lodInheritMaterial = true;

        [Space]
        [Tooltip(
            "The colliders belonging to this surface that particles can hit and then paint. A paintable collider can be shared between multiple surfaces.\n\nThis will only work with Paintables marked as non-legacy!")]
        [SerializeField]
        private List<Paintable> paintableColliders;

        private void Start()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }

        public void CopyMaterialsFrom(PaintSurface from)
        {
            throw new NotImplementedException();
        }

        public void ConnectPaintable(Paintable paintable)
        {
            throw new NotImplementedException();
        }

        public void DisconnectPaintable(Paintable paintable)
        {
            throw new NotImplementedException();
        }
    }
}