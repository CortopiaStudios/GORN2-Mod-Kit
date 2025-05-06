// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Painting
{
    public interface IPaintable
    {
    }

    public class Paintable : MonoBehaviour, IPaintable
    {
        [Tooltip(
            "If true, the Paintable will refer to its connected PaintSurface via the field below. If false, multiple connections can be made from PaintSurface components.")]
        [SerializeField]
        private bool useLegacyConnection = true;

        [SerializeField]
        private PaintSurface paintSurface;
        [Tooltip(
            "If this is set the component will in Awake try to find a PaintSurface under the referenced game object. This would overrider the value on Paint Surface.")]
        [SerializeField]
        private BoundValue<GameObject> paintSurfaceParent;

        public void ConnectPaintSurface(PaintSurface surface)
        {
            throw new NotImplementedException();
        }

        public void DisconnectPaintSurface(PaintSurface surface)
        {
            throw new NotImplementedException();
        }
    }
}