// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Utils.Editor
{
    [CustomEditor(typeof(Comment))]
    public class CommentEditor : UnityEditor.Editor
    {
        private const int LabelWidth = 50;
        private const int WidthInteger2Digits = 21;
        private const int WidthInteger4Digits = 35;
        
        public override void OnInspectorGUI()
        {
            var script = (Comment) this.target;

            EditorGUILayout.Space(5);
            script.comment = EditorGUILayout.TextArea(script.comment, new GUIStyle(GUI.skin.textArea) {wordWrap = true});

            GUILayout.Space(5);
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("Author:", GUILayout.Width(LabelWidth));
            script.author = EditorGUILayout.TextField(script.author, new GUIStyle(GUI.skin.textField) {wordWrap = false}, GUILayout.Width(200));
            
            GUILayout.Space(10);

            GUILayout.Label("Date:", GUILayout.Width(LabelWidth));
            script.dateDay = EditorGUILayout.IntField(script.dateDay, GUILayout.Width(WidthInteger2Digits));
            script.dateMonth = EditorGUILayout.IntField(script.dateMonth, GUILayout.Width(WidthInteger2Digits));
            script.dateYear = EditorGUILayout.IntField(script.dateYear, GUILayout.Width(WidthInteger4Digits));
            
            EditorGUILayout.EndHorizontal();
            
            EditorGUILayout.Space(5);

            if (GUI.changed)
            {
                EditorUtility.SetDirty(this.target);
            }
        }
    }
}