// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Editor
{
    [CustomPropertyDrawer(typeof(ReactiveSource<>))]
    public class ReactiveSourceDrawer : PropertyDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            SerializedProperty triggerProperty = property.FindPropertyRelative("reactiveTrigger");
            SerializedProperty triggerValueProperty = triggerProperty.FindPropertyRelative("value");
            SerializedProperty debugProperty = triggerProperty.FindPropertyRelative("breakOnChange");

            return EditorGUI.GetPropertyHeight(triggerValueProperty, label) + EditorGUI.GetPropertyHeight(debugProperty, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.BeginProperty(position, label, property);

            SerializedProperty triggerProperty = property.FindPropertyRelative("reactiveTrigger");
            SerializedProperty triggerValueProperty = triggerProperty.FindPropertyRelative("value");
            SerializedProperty debugProperty = triggerProperty.FindPropertyRelative("breakOnChange");

            position.height = EditorGUI.GetPropertyHeight(triggerValueProperty, label);

            bool isPlaying = EditorApplication.isPlaying;
            if (isPlaying)
            {
                EditorGUI.BeginChangeCheck();
            }

            EditorGUI.PropertyField(position, triggerValueProperty, label, true);
            position.y += position.height;
            position.height = EditorGUI.GetPropertyHeight(debugProperty, label);
            const float widthAdjustment = 2;
            position.x += widthAdjustment + EditorGUIUtility.labelWidth;
            position.width = 110;

            bool didChange = isPlaying && EditorGUI.EndChangeCheck();

            debugProperty.boolValue = GUI.Toggle(position, debugProperty.boolValue, "Break on change", new GUIStyle("Button") {alignment = TextAnchor.MiddleCenter});

            if (didChange)
            {
                var reactiveHandlers = ReactiveDrawerHelpers.GetObjects<IReactiveHandler>(triggerProperty).ToArray();
                foreach (IReactiveHandler handler in reactiveHandlers)
                {
                    handler.OnValueChanging();
                }

                triggerValueProperty.serializedObject.ApplyModifiedProperties();
                foreach (IReactiveHandler handler in reactiveHandlers)
                {
                    handler.OnValueChanged();
                }
            }

            EditorGUI.EndProperty();
        }
    }
}