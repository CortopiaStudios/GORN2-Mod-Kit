// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents.Editor
{
    [CustomEditor(typeof(ReactiveCounter))]
    public class ReactiveCounterEditor : UnityEditor.Editor
    {
        private ReactiveCounter _eventObject;

        private void OnEnable()
        {
            this._eventObject = this.target as ReactiveCounter;
        }

        public override void OnInspectorGUI()
        {
            this.serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            {
                if (GUILayout.Button("Increase counter", GUILayout.Height(32)))
                {
                    this._eventObject.IncreaseCounter();
                }
            }
            EditorGUILayout.EndHorizontal();

            this.serializedObject.ApplyModifiedProperties();
        }
    }
}