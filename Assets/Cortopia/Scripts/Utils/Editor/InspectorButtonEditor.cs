// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Utils.Editor
{
    [CustomEditor(typeof(MonoBehaviour), true)]
    [CanEditMultipleObjects]
    public class InspectorButtonEditor : UnityEditor.Editor
    {
        private readonly List<(MethodInfo, InspectorButtonAttribute)> _foundButtons = new();

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            if (this.targets.Length > 1)
            {
                return;
            }

            var targetObj = (MonoBehaviour) this.target;
            var methods = targetObj.GetType().GetMethods(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);

            this._foundButtons.Clear();

            foreach (MethodInfo method in methods)
            {
                var attribute = (InspectorButtonAttribute) method.GetCustomAttribute(typeof(InspectorButtonAttribute), false);

                if (attribute != null)
                {
                    this._foundButtons.Add((method, attribute));
                }
            }

            if (this._foundButtons == null || this._foundButtons.Count == 0)
            {
                return;
            }

            const int spaceBetweenButtonsAndTheRest = 10;
            const int spaceBetweenLineAndButtons = 5;

            EditorGUILayout.Space(spaceBetweenButtonsAndTheRest);
            EditorGUILayout.LabelField("Editor Functions", EditorStyles.boldLabel);

            Rect rect = EditorGUILayout.GetControlRect(false, 1f);
            EditorGUI.DrawRect(rect, new Color(0.5f, 0.5f, 0.5f, 1f));

            EditorGUILayout.Space(spaceBetweenLineAndButtons);

            foreach ((MethodInfo, InspectorButtonAttribute) button in this._foundButtons)
            {
                if (!button.Item2.CanBePressed)
                {
                    EditorGUI.BeginDisabledGroup(true);
                    GUILayout.Button(button.Item2.ButtonName);
                    EditorGUI.EndDisabledGroup();
                    continue;
                }

                if (GUILayout.Button(button.Item2.ButtonName))
                {
                    button.Item1.Invoke(targetObj, null);
                }
            }
        }
    }
}