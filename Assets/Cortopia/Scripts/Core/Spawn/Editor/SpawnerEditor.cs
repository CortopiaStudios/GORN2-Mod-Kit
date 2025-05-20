// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Core.Spawn.Editor
{
    [CustomEditor(typeof(Spawner), true)]
    public class SpawnerEditor : UnityEditor.Editor
    {
        private readonly Dictionary<string, Type> _spawnerParameters = new();
        private SpawnerParameter[] _allComponents;
        private SpawnerParameter[] _prefabParameters;
        private Spawner _targetSpawner;

        private void OnEnable()
        {
            this._targetSpawner = (Spawner) this.target;
            this.Init();
        }

        private void Init()
        {
            GameObject spawnerPrefab = this._targetSpawner.Prefab;
            if (spawnerPrefab)
            {
                this._prefabParameters = spawnerPrefab.GetComponents<SpawnerParameter>();
            }
        }

        public override void OnInspectorGUI()
        {
            this.serializedObject.Update();
            if (this.DrawDefaultInspector())
            {
                this.serializedObject.ApplyModifiedProperties();
                this.Init();
            }

            EditorGUILayout.BeginHorizontal();
            this._spawnerParameters.Clear();
            foreach (SpawnerParameter component in this._targetSpawner.GetComponents<SpawnerParameter>())
            {
                this._spawnerParameters[component.parameterName ?? ""] = component.ParameterType;
            }

            if (this._prefabParameters != null && !this._prefabParameters.All(this.AlreadyCreated))
            {
                GUI.backgroundColor = new Color(1, 0.2f, 0.2f);
                if (GUILayout.Button("Create missing parameters", GUILayout.Height(32)))
                {
                    Type spawnerParameterBase = typeof(SpawnerParameter<>);
                    Dictionary<Type, Type> spawnerParameterTypes = new();
                    foreach (Type type in spawnerParameterBase.Assembly.GetTypes())
                    {
                        if (type == spawnerParameterBase)
                        {
                            continue;
                        }

                        Type genericBase = GetGenericBaseType(type, spawnerParameterBase);
                        if (genericBase != null)
                        {
                            spawnerParameterTypes[genericBase.GenericTypeArguments[0]] = type;
                        }
                    }

                    GameObject targetGameObject = this._targetSpawner.gameObject;
                    foreach (SpawnerParameter parameter in this._prefabParameters)
                    {
                        if (!this._targetSpawner.AllowOutParameters && parameter.direction == SpawnerParameter.Direction.Out)
                        {
                            // Do not show out parameters if not allowed
                            continue;
                        }

                        if (this.AlreadyCreated(parameter))
                        {
                            continue;
                        }

                        if (spawnerParameterTypes.TryGetValue(parameter.ParameterType, out Type spawnerParameterType))
                        {
                            var spawnerParameter = (SpawnerParameter) targetGameObject.AddComponent(spawnerParameterType);
                            spawnerParameter.parameterName = parameter.parameterName;
                            spawnerParameter.direction = this._targetSpawner.AllowOutParameters ? parameter.direction : SpawnerParameter.Direction.In;
                        }
                        else
                        {
                            Debug.LogWarning($"Cannot create a spawner parameter of type {parameter.ParameterType.Name}");
                        }
                    }
                }
            }

            EditorGUILayout.EndHorizontal();
        }

        private static Type GetGenericBaseType(Type type, Type openGenericType)
        {
            while (type != null)
            {
                if (type.IsGenericType && type.GetGenericTypeDefinition() == openGenericType)
                {
                    return type;
                }

                type = type.BaseType;
            }

            return null;
        }

        private bool AlreadyCreated(SpawnerParameter prefabParameter)
        {
            return (!this._targetSpawner.AllowOutParameters && prefabParameter.direction == SpawnerParameter.Direction.Out) ||
                   (this._spawnerParameters.TryGetValue(prefabParameter.parameterName, out Type expectedType) && expectedType == prefabParameter.ParameterType);
        }
    }
}