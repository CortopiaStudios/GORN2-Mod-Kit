// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Linq;
using Cortopia.Scripts.Reactivity.Singletons.Types;
using Cortopia.Scripts.Reactivity.Transitions;
using UnityEditor;

namespace Cortopia.Scripts.Reactivity.Editor
{
    [CanEditMultipleObjects]
    [CustomEditor(typeof(ReactiveStateTransition))]
    public class ReactiveStateTransitionEditor : UnityEditor.Editor
    {
        private SerializedProperty _doTransitionProperty;
        private SerializedProperty _fromProperty;
        private string[] _states;
        private SerializedProperty _stateVariableProperty;
        private SerializedProperty _toProperty;

        private void OnEnable()
        {
            this._fromProperty = this.serializedObject.FindProperty("fromState");
            this._toProperty = this.serializedObject.FindProperty("toState");
            this._stateVariableProperty = this.serializedObject.FindProperty("stateVariable");
            this._doTransitionProperty = this.serializedObject.FindProperty("doTransition");
        }

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginDisabledGroup(true);
            EditorGUILayout.PropertyField(this.serializedObject.FindProperty("m_Script"));
            EditorGUI.EndDisabledGroup();
            this.serializedObject.Update();
            EditorGUILayout.PropertyField(this._doTransitionProperty);
            DrawGlobalStates(this.serializedObject, this._stateVariableProperty, this._fromProperty, this._toProperty);
            this.serializedObject.ApplyModifiedProperties();
        }

        public static void DrawGlobalStates(SerializedObject target, SerializedProperty state, SerializedProperty first, SerializedProperty second)
        {
            EditorGUILayout.PropertyField(state);

            if (!string.IsNullOrEmpty(first.stringValue) && !string.IsNullOrEmpty(second.stringValue) && first.stringValue.Equals(second.stringValue))
            {
                EditorGUILayout.HelpBox("From and To value can't be the same value", MessageType.Error);
            }

            DrawGlobalStatePopup(target, state, first, false);
            DrawGlobalStatePopup(target, state, second, false);
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
                popup.stringValue = states[index].Replace(" ", string.Empty);
                PrefabUtility.RecordPrefabInstancePropertyModifications(target.targetObject);
            }
        }
    }
}