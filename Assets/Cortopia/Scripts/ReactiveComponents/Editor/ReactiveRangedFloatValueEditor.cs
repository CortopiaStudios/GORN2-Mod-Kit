// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEditor;

namespace Cortopia.Scripts.ReactiveComponents.Editor
{
    [CustomEditor(typeof(ReactiveRangedFloatValue))]
    public class ReactiveRangedFloatValueEditor : UnityEditor.Editor
    {
        private ReactiveRangedFloatValue _property;

        private void OnEnable()
        {
            this._property = this.target as ReactiveRangedFloatValue;
        }

        public override void OnInspectorGUI()
        {
            this.serializedObject.Update();

            SerializedProperty minValue = this.serializedObject.FindProperty("minValue");
            EditorGUILayout.PropertyField(minValue);

            SerializedProperty maxValue = this.serializedObject.FindProperty("maxValue");
            EditorGUILayout.PropertyField(maxValue);

            SerializedProperty unclampedValue = this.serializedObject.FindProperty("unclampedValue");
            SerializedProperty floatValue = unclampedValue.FindPropertyRelative("reactiveTrigger.value");
            floatValue.floatValue = EditorGUILayout.Slider("Value", floatValue.floatValue, minValue.floatValue, maxValue.floatValue);
            this._property.UnclampedValue.Value = floatValue.floatValue;

            this.serializedObject.ApplyModifiedProperties();
        }
    }
}