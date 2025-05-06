// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using FMODUnity;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents.Editor
{
    [CustomEditor(typeof(ReactorGlobalAudioParameter))]
    public class ReactorGlobalAudioParameterEditor : UnityEditor.Editor
    {
        private SerializedProperty _param;
        private SerializedProperty _value;

        private SerializedProperty _data1, _data2;

        private static GUIContent _notFoundWarning;

        private string _currentPath;

        [SerializeField]
        private EditorParamRef editorParamRef;

        private void OnEnable()
        {
            this._param = this.serializedObject.FindProperty("parameterName");
            this._value = this.serializedObject.FindProperty("value");
        }

        public override void OnInspectorGUI()
        {
            if (_notFoundWarning == null)
            {
                Texture warningIcon = EditorUtils.LoadImage("NotFound.png");
                _notFoundWarning = new GUIContent("Parameter Not Found", warningIcon);
            }

            EditorGUILayout.PropertyField(this._value, new GUIContent("Value"));
            EditorGUILayout.PropertyField(this._param, new GUIContent("Parameter"));

            if (this._param.stringValue != this._currentPath)
            {
                this._currentPath = this._param.stringValue;

                if (string.IsNullOrEmpty(this._param.stringValue))
                {
                    this.editorParamRef = null;
                }
                else
                {
                    this.editorParamRef = EventManager.ParamFromPath(this._param.stringValue);
                }
            }

            if (this.editorParamRef == null)
            {
                Rect rect = EditorGUILayout.GetControlRect();
                rect.xMin += EditorGUIUtility.labelWidth;

                GUI.Label(rect, _notFoundWarning);
            }

            this.serializedObject.ApplyModifiedProperties();
        }
    }
}