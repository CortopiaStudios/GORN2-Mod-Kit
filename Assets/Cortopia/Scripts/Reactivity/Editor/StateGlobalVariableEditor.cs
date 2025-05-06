// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Linq;
using System.Text.RegularExpressions;
using Cortopia.Scripts.Reactivity.Singletons.Types;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Editor
{
    [CustomEditor(typeof(StateGlobalVariable))]
    public class StateGlobalVariableEditor : UnityEditor.Editor
    {
        private static readonly Regex Regex = new(@"([A-Z][a-z]+|[A-Z]+[A-Z]|[A-Z]|[^A-Za-z]+[^A-Za-z])", RegexOptions.RightToLeft);
        
        private ReorderableList _states;
        private SerializedProperty _statesProperty;
        private StateGlobalVariable Target => (StateGlobalVariable) this.target;

        protected virtual bool Draggable => true;
        protected virtual bool Addable => true;
        protected virtual bool Removable => true;

        private void OnEnable()
        {
            this._statesProperty = this.serializedObject.FindProperty("states");
            this._states = new ReorderableList(this.serializedObject, this._statesProperty, this.Draggable, true, this.Addable, this.Removable)
            {
                drawHeaderCallback = DrawHeader, drawElementCallback = this.DrawElement, onChangedCallback = this.OnListChange
            };
        }

        private void OnListChange(ReorderableList list)
        {
            this.serializedObject.ApplyModifiedProperties();
        }

        private void DrawElement(Rect rect, int index, bool isActive, bool isFocused)
        {
            SerializedProperty element = this._statesProperty.GetArrayElementAtIndex(index);
            rect.y += 3;
            rect.height = EditorGUIUtility.singleLineHeight;
            EditorGUI.PropertyField(rect, element);
        }

        private static void DrawHeader(Rect rect)
        {
            EditorGUI.LabelField(rect, "States");
        }

        public static string SplitCase(string s)
        {
            return Regex.Replace(s, " $1").TrimStart(' ');
        }

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginDisabledGroup(true);
            EditorGUILayout.PropertyField(this.serializedObject.FindProperty("m_Script"));
            EditorGUI.EndDisabledGroup();
            this.serializedObject.Update();
            EditorGUI.BeginChangeCheck();
            this.Target.Variable.Value = EditorGUILayout.Popup("Active State", this.Target.Variable.Value, this.Target.States.Select(SplitCase).ToArray());
            if (EditorGUI.EndChangeCheck() && !EditorApplication.isPlaying)
            {
                EditorUtility.SetDirty(this.Target);
                AssetDatabase.SaveAssetIfDirty(this.Target);
            }

            EditorGUILayout.Space();
            this._states.DoLayoutList();
            this.serializedObject.ApplyModifiedProperties();
        }
    }

    [CustomEditor(typeof(EnumGlobalVariable<>), true)]
    public sealed class EnumGlobalVariableEditor : StateGlobalVariableEditor
    {
        protected override bool Draggable => false;
        protected override bool Addable => false;
        protected override bool Removable => false;
    }
}