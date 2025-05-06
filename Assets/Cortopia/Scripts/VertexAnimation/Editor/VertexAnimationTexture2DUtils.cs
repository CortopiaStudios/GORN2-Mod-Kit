// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    public static class VertexAnimationTexture2DUtils
    {
        public static Texture2D CreateTexture(
            List<List<Vector3>> vectors3, bool useMipChain, bool isLinear, TextureWrapMode wrapMode = TextureWrapMode.Repeat, FilterMode filterMode = FilterMode.Bilinear,
            int anisoLevel = 1, string name = "", bool makeNoLongerReadable = true)
        {
            if (vectors3.Count == 0)
            {
                return null;
            }

            int textureWidth = vectors3[0].Count;
            int textureHeight = vectors3.Count;

            var texture = new Texture2D(textureWidth, textureHeight, TextureFormat.RGBAHalf, useMipChain, isLinear);

            int y = 0;
            foreach (var vectorLine in vectors3)
            {
                int x = 0;
                foreach (Vector3 v in vectorLine)
                {
                    texture.SetPixel(x, y, new Color(v.x, v.y, v.z, 1));
                    x++;
                }

                y++;
            }

            texture.wrapMode = wrapMode;
            texture.filterMode = filterMode;
            texture.anisoLevel = anisoLevel;
            texture.name = name;

            texture.Apply(false, makeNoLongerReadable);

            return texture;
        }
    }
}