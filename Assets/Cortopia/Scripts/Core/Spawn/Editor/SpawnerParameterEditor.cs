// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace Cortopia.Scripts.Core.Spawn.Editor
{
    [CustomEditor(typeof(SpawnerParameter), true)]
    public class SpawnerParameterEditor : UnityEditor.Editor
    {
        private GUIStyle _errorStyle;
        private bool _isValid;
        private bool _outParametersAllowed;
        private SpawnerParameter[] _prefabParameters;
        private SpawnerParameter _targetParameter;

        private void OnEnable()
        {
            this._errorStyle = new GUIStyle {fontStyle = FontStyle.Bold, normal = {textColor = new Color(1, 0.2f, 0.2f)}};
            this._targetParameter = (SpawnerParameter) this.target;

            if (this._targetParameter.EditorAlwaysAllowed)
            {
                this._isValid = true;
                this._outParametersAllowed = true;
            }
            else if (this._targetParameter.GetComponent<Spawner>() is { } spawner)
            {
                this._isValid = true;
                this._outParametersAllowed = spawner.AllowOutParameters;
                GameObject spawnerPrefab = spawner.Prefab;
                if (spawnerPrefab)
                {
                    this._prefabParameters = spawnerPrefab.GetComponents<SpawnerParameter>();
                }
            }
            else if (PrefabStageUtility.GetCurrentPrefabStage() != null)
            {
                this._isValid = this._targetParameter.gameObject == PrefabStageUtility.GetCurrentPrefabStage().prefabContentsRoot;
                this._outParametersAllowed = true;
            }
            else
            {
                // Check if viewing the prefab asset root in project view
                this._isValid = this._targetParameter.transform.root.gameObject == this._targetParameter.gameObject &&
                                PrefabUtility.IsPartOfPrefabAsset(this._targetParameter);
                this._outParametersAllowed = true;
            }
        }

        public override void OnInspectorGUI()
        {
            this.serializedObject.Update();

            SerializedProperty parameterName = this.serializedObject.FindProperty("parameterName");
            SerializedProperty direction = this.serializedObject.FindProperty("direction");
            SerializedProperty boundValue = this.serializedObject.FindProperty("boundValue");

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.BeginVertical(GUILayout.MaxWidth(EditorGUIUtility.labelWidth));
            EditorGUILayout.PropertyField(parameterName, GUIContent.none);
            EditorGUILayout.PropertyField(direction, GUIContent.none, GUILayout.MaxWidth(60));
            EditorGUILayout.EndVertical();
            EditorGUIUtility.labelWidth = 0.1f;
            EditorGUILayout.PropertyField(boundValue, GUIContent.none, true);
            EditorGUILayout.EndHorizontal();

            this.serializedObject.ApplyModifiedProperties();
            
            if (!this._isValid)
            {
                this.AddError("SpawnerParameter is only valid in the root of a prefab or in the same GameObject as a spawner");
                return;
            }

            if (this._targetParameter.GetComponents<SpawnerParameter>().Any(x => x != this._targetParameter && x.parameterName == this._targetParameter.parameterName))
            {
                this.AddError($"Parameter '{this._targetParameter.parameterName}' is already declared");
            }

            if (!this._outParametersAllowed && this._targetParameter.direction != SpawnerParameter.Direction.In)
            {
                this.AddError("Only in-parameters are allowed for this kind of spawner");
            }

            if (this._prefabParameters != null)
            {
                if (this._prefabParameters.FirstOrDefault(x => x.parameterName == this._targetParameter.parameterName) is not { } prefabParameter)
                {
                    this.AddError($"Parameter '{this._targetParameter.parameterName}' does not exist in this prefab");
                }
                else if (prefabParameter.ParameterType != this._targetParameter.ParameterType)
                {
                    this.AddError($"Parameter '{this._targetParameter.parameterName}' must be of type {prefabParameter.ParameterType.Name}");
                }
                else if (prefabParameter.direction == SpawnerParameter.Direction.In && this._targetParameter.direction == SpawnerParameter.Direction.Out)
                {
                    this.AddError($"Parameter '{this._targetParameter.parameterName}' is not allowing output");
                }
                else if (prefabParameter.direction == SpawnerParameter.Direction.Out && this._targetParameter.direction == SpawnerParameter.Direction.In)
                {
                    this.AddError($"Parameter '{this._targetParameter.parameterName}' is not allowing input");
                }
            }
        }

        private void AddError(string s)
        {
            EditorGUILayout.LabelField(s, this._errorStyle);
        }
    }
}