// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEditor;

namespace Cortopia.Scripts.ReactiveComponents.Editor
{
    [CustomEditor(typeof(ReactiveRangedIntValue))]
    public class ReactiveRangedIntValueEditor : UnityEditor.Editor
    {
        private ReactiveRangedIntValue _property;

        private void OnEnable()
        {
            this._property = this.target as ReactiveRangedIntValue;
        }

        public override void OnInspectorGUI()
        {
            this.serializedObject.Update();

            SerializedProperty minValue = this.serializedObject.FindProperty("minValue");
            EditorGUILayout.PropertyField(minValue);

            SerializedProperty maxValue = this.serializedObject.FindProperty("maxValue");
            EditorGUILayout.PropertyField(maxValue);

            SerializedProperty unclampedValue = this.serializedObject.FindProperty("unclampedValue");
            SerializedProperty intValue = unclampedValue.FindPropertyRelative("reactiveTrigger.value");
            intValue.intValue = EditorGUILayout.IntSlider("Value", intValue.intValue, minValue.intValue, maxValue.intValue);
            this._property.UnclampedValue.Value = intValue.intValue;

            this.serializedObject.ApplyModifiedProperties();
        }
    }
}