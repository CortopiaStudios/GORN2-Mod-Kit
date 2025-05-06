// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Unity.AI.Navigation.Editor;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.AI.Navigation.Editor
{
    [CustomPropertyDrawer(typeof(NavMeshAgentType))]
    public class NavMeshAgentTypeDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.BeginProperty(position, label, property);
            EditorGUILayout.BeginHorizontal();

            SerializedProperty id = property.FindPropertyRelative(nameof(NavMeshAgentType.id));

            string name = ObjectNames.NicifyVariableName(nameof(NavMeshAgentType));
            NavMeshComponentsGUIUtility.AgentTypePopup(name, id);

            EditorGUILayout.EndHorizontal();
            EditorGUI.EndProperty();
        }
    }
}