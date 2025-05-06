// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Linq;
using Cortopia.Scripts.Reactivity.Operators;
using Cortopia.Scripts.Reactivity.Singletons.Types;
using UnityEditor;

namespace Cortopia.Scripts.Reactivity.Editor
{
    [CanEditMultipleObjects]
    [CustomEditor(typeof(ReactiveStateComparer))]
    public class ReactiveStateComparerEditor : UnityEditor.Editor
    {
        private SerializedProperty _conditionOperator;
        private SerializedProperty _conditionStateProperty;
        private SerializedProperty _reactiveNameProperty;
        private SerializedProperty _stateProperty;

        private void OnEnable()
        {
            this._reactiveNameProperty = this.serializedObject.FindProperty("reactiveName");
            this._stateProperty = this.serializedObject.FindProperty("stateVariable");
            this._conditionStateProperty = this.serializedObject.FindProperty("conditionState");
            this._conditionOperator = this.serializedObject.FindProperty("conditionOperator");
        }

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginDisabledGroup(true);
            EditorGUILayout.PropertyField(this.serializedObject.FindProperty("m_Script"));
            EditorGUI.EndDisabledGroup();
            this.serializedObject.Update();
            EditorGUILayout.PropertyField(this._reactiveNameProperty);
            EditorGUILayout.PropertyField(this._stateProperty);
            DrawGlobalStatePopup(this.serializedObject, this._stateProperty, this._conditionStateProperty, true);
            EditorGUILayout.PropertyField(this._conditionOperator);
            this.serializedObject.ApplyModifiedProperties();
        }

        public static void DrawGlobalStatePopup(SerializedObject target, SerializedProperty state, SerializedProperty popup, bool includeIndexInName)
        {
            string[] states = Array.Empty<string>();
            int index = -1;

            if (state.objectReferenceValue is StateGlobalVariable stateObject)
            {
                states = stateObject.States.Select(StateGlobalVariableEditor.SplitCase).ToArray();
                index = stateObject.States.IndexOf(popup.stringValue);
            }

            EditorGUI.BeginChangeCheck();

            const int invalidIndex = -1;
            if (index == invalidIndex)
            {
                EditorGUILayout.HelpBox(string.IsNullOrEmpty(popup.stringValue) ? "Value not set" : $"Value not found! Saved value was: {popup.stringValue.ToUpper()}",
                    MessageType.Error);
            }

            const string labelFormat = "{0} ({1})";
            index = EditorGUILayout.Popup(includeIndexInName ? string.Format(labelFormat, popup.displayName, index) : popup.displayName, index, states);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(target.targetObject, "Undo Set State");
                popup.stringValue = TrimAll(states[index]);
                PrefabUtility.RecordPrefabInstancePropertyModifications(target.targetObject);
            }
        }

        public static string TrimAll(string value)
        {
            return value.Replace(" ", string.Empty);
        }
    }
}