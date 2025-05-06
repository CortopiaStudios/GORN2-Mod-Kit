// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    public static class EditorGUILayoutUtils
    {
        public static readonly Color HorizontalLineColor = Color.white;

        public static void HorizontalLine(Color color)
        {
            Color prev = GUI.color;
            GUI.color = color;
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
            GUI.color = prev;
        }

        public static void HorizontalLine()
        {
            HorizontalLine(HorizontalLineColor);
        }
    }
}