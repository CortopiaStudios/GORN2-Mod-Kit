// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Utils.Editor
{
    [CustomPropertyDrawer(typeof(ReadOnlyAttribute))]
    public class ReadOnlyDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            bool cachedGUIState = GUI.enabled;

            GUI.enabled = false;
            EditorGUI.PropertyField(position, property, label);
            GUI.enabled = cachedGUIState;
        }
    }
}