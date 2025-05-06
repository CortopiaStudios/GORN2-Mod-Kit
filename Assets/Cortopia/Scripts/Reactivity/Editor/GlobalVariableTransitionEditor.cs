// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity.Transitions;
using UnityEditor;

namespace Cortopia.Scripts.Reactivity.Editor
{
    [CustomEditor(typeof(GlobalVariableTransition<>), true)]
    public class GlobalVariableTransitionEditor : UnityEditor.Editor
    {
        private SerializedProperty _allowTransitionFromAnyStateProperty;
        private SerializedProperty _doTransitionProperty;
        private SerializedProperty _fromValueProperty;
        private SerializedProperty _targetValuesProperty;
        private SerializedProperty _toValueProperty;

        private void OnEnable()
        {
            this._doTransitionProperty = this.serializedObject.FindProperty("doTransition");
            this._allowTransitionFromAnyStateProperty = this.serializedObject.FindProperty("alwaysTransition");
            this._fromValueProperty = this.serializedObject.FindProperty("fromValue");
            this._toValueProperty = this.serializedObject.FindProperty("toValue");
            this._targetValuesProperty = this.serializedObject.FindProperty("targetValues");
        }

        public override void OnInspectorGUI()
        {
            // Draw script reference
            EditorGUI.BeginDisabledGroup(true);
            EditorGUILayout.PropertyField(this.serializedObject.FindProperty("m_Script"));
            EditorGUI.EndDisabledGroup();
            
            this.serializedObject.Update();
            
            EditorGUILayout.PropertyField(this._doTransitionProperty);
            EditorGUILayout.PropertyField(this._allowTransitionFromAnyStateProperty);
            
            if (!this._allowTransitionFromAnyStateProperty.boolValue)
            {
                EditorGUILayout.PropertyField(this._fromValueProperty);
            }

            EditorGUILayout.PropertyField(this._toValueProperty);
            EditorGUILayout.PropertyField(this._targetValuesProperty);
            
            this.serializedObject.ApplyModifiedProperties();
        }
    }
}