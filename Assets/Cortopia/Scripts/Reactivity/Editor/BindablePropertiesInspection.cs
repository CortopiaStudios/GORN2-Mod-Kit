// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using JetBrains.Annotations;
using UnityEditor;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Reactivity.Editor
{
    public static class BindablePropertiesInspection
    {
        [MenuItem("CONTEXT/MonoBehaviour/Bindable properties...")]
        private static void InspectBindableProperties(MenuCommand command)
        {
            var monoBehaviour = (MonoBehaviour) command.context;
            Assert.IsNotNull(monoBehaviour);
            // Get existing open window or if none, make a new one:
            var window = (BindablePropertiesWindow) EditorWindow.GetWindow(typeof(BindablePropertiesWindow));
            window.monoBehaviour = monoBehaviour;
            window.Show();
        }

        private static Dictionary<Bindable, List<(Object owner, BoundValueField boundValue)>> ObjectBindablesSceneUsages(Object obj, Scene scene)
        {
            var objBindables = ObjectBindableProperties(obj).ToDictionary(b => b, _ => new List<(Object, BoundValueField)>());

            foreach (GameObject go in scene.GetRootGameObjects())
            {
                foreach (MonoBehaviour mb in go.GetComponentsInChildren<MonoBehaviour>(true))
                {
                    // The MonoBehaviours are sometimes null for some reason
                    if (!mb)
                    {
                        continue;
                    }

                    foreach (BoundValueField b in ObjectBoundValues(mb))
                    {
                        if (b.Reference == obj && objBindables.TryGetValue(b.Bindable, out var l))
                        {
                            l.Add((mb, b));
                        }
                    }
                }
            }

            return objBindables;
        }

        private static IEnumerable<Bindable> ObjectBindableProperties(Object obj)
        {
            Type bindableInterface = obj.GetType().GetInterface(typeof(IBindableReactive<>).Name);
            if (bindableInterface != null)
            {
                yield return new Bindable.Reference(obj.GetType());
            }

            foreach (PropertyInfo p in obj.GetType().GetProperties())
            {
                Bindable.Property b = BindableFromObjectProperty(obj, p);
                if (b != null)
                {
                    yield return b;
                }
            }
        }

        [CanBeNull]
        private static Bindable.Property BindableFromObjectProperty(Object obj, PropertyInfo property)
        {
            if (!property.CanRead || !property.GetMethod.IsPublic)
            {
                return null;
            }

            var typeArguments = property.PropertyType.GenericTypeArguments;
            Type bindableType = typeArguments.Length == 1 ? typeof(IBindableReactive<>).MakeGenericType(property.PropertyType.GenericTypeArguments) : null;

            bool isReactive = bindableType != null;
            IBindableReactive maybeBindable = isReactive ? property.GetValue(obj) as IBindableReactive : null;

            bool isReadOnly = maybeBindable?.IsReadOnly ?? (!property.CanWrite || !property.SetMethod.IsPublic);

            return new Bindable.Property(property.Name, property.DeclaringType, isReactive, isReadOnly, FindDerivingIndex(property.DeclaringType, obj.GetType()));
        }

        private static int FindDerivingIndex(Type baseType, Type derivingType)
        {
            int i = 0;
            while (true)
            {
                if (derivingType == baseType)
                {
                    return i;
                }

                if (derivingType == null)
                {
                    return -1;
                }

                i += 1;
                derivingType = derivingType.BaseType;
            }
        }

        private static IEnumerable<BoundValueField> ObjectBoundValues(Object obj)
        {
            var serializedObj = new SerializedObject(obj);

            foreach (FieldInfo f in obj.GetType().GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
            {
                var typeArguments = f.FieldType.GenericTypeArguments;
                if (typeArguments.Length != 1)
                {
                    continue;
                }

                Type boundValueType = typeof(BoundValue<>).MakeGenericType(f.FieldType.GenericTypeArguments);
                if (f.FieldType != boundValueType)
                {
                    continue;
                }

                FieldInfo referenceField = boundValueType.GetField("reference", BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo propertyNameField = boundValueType.GetField("propertyName", BindingFlags.Instance | BindingFlags.NonPublic);

                Assert.IsNotNull(referenceField);
                Assert.IsNotNull(propertyNameField);

                object boundValue = f.GetValue(obj);
                var reference = referenceField.GetValue(boundValue) as Object;
                string propertyName = propertyNameField.GetValue(boundValue) as string;
                if (!reference || propertyName == null)
                {
                    continue;
                }

                if (propertyName.Length == 0)
                {
                    Type bindableInterface = reference.GetType().GetInterface(typeof(IBindableReactive<>).Name);
                    if (bindableInterface != null)
                    {
                        yield return new BoundValueField {Reference = reference, Field = f, Bindable = new Bindable.Reference(reference.GetType())};
                    }
                }
                else
                {
                    PropertyInfo boundProperty = reference.GetType().GetProperty(propertyName);
                    if (boundProperty == null)
                    {
                        continue;
                    }

                    Bindable.Property bindable = BindableFromObjectProperty(reference, boundProperty);

                    Assert.IsNotNull(bindable);

                    if (serializedObj.FindProperty(f.Name) == null)
                    {
                        continue;
                    }

                    yield return new BoundValueField {Reference = reference, Bindable = bindable, Field = f};
                }
            }
        }

        private class BindablePropertiesWindow : EditorWindow
        {
            public MonoBehaviour monoBehaviour;

            private void OnEnable()
            {
                this.titleContent = new GUIContent("Bindable Properties");
            }

            private void OnGUI()
            {
                if (!this.monoBehaviour)
                {
                    return;
                }

                GUI.enabled = false;
                EditorGUILayout.ObjectField(this.monoBehaviour, this.monoBehaviour.GetType(), true);
                GUI.enabled = true;

                foreach ((Bindable bindable, var usages) in ObjectBindablesSceneUsages(this.monoBehaviour, this.monoBehaviour.gameObject.scene)
                             .OrderBy(x => x.Key switch
                             {
                                 Bindable.Reference => 0,
                                 Bindable.Property property => property.IsReactive ? !property.IsReadOnly ? 1 : 2 : 3 + property.DerivingIndex,
                                 _ => throw new ArgumentOutOfRangeException()
                             }))
                {
                    string label = bindable switch
                    {
                        Bindable.Property(var pName, var type, var reactive, var readOnly, _) =>
                            $"{(!reactive ? "[non-reactive] " : string.Empty)}{type.Name}.{pName}{(readOnly ? " [read only]" : string.Empty)}",
                        Bindable.Reference(var type) => type.Name,
                        _ => throw new ArgumentOutOfRangeException(nameof(bindable))
                    };

                    GUILayout.BeginHorizontal();
                    EditorGUILayout.LabelField(label);

                    if (usages.Count > 0)
                    {
                        GUILayout.Label($"{usages.Count} {(usages.Count == 1 ? "usage" : "usages")}", EditorStyles.linkLabel);
                        int clickedIndex = EditorGUI.Popup(GUILayoutUtility.GetLastRect(), -1,
                            usages.Select(x => $"{x.owner.name} ({x.boundValue.Field.DeclaringType!.FullName}.{x.boundValue.Field.Name})").ToArray(),
                            new GUIStyle {border = {left = 0, top = 0, right = 0, bottom = 0}});
                        if (clickedIndex != -1)
                        {
                            GameObject selectObj = usages[clickedIndex].owner switch
                            {
                                MonoBehaviour mb => mb.gameObject,
                                GameObject go => go,
                                _ => null
                            };
                            if (selectObj)
                            {
                                Selection.objects = new Object[] {selectObj};
                            }

                            EditorGUIUtility.PingObject(usages[clickedIndex].owner);
                        }
                    }

                    GUILayout.EndHorizontal();
                }
            }
        }

        private struct BoundValueField
        {
            public FieldInfo Field;
            public Bindable Bindable;
            public Object Reference;
        }

        private abstract record Bindable
        {
            public record Reference(Type Type) : Bindable
            {
                public Type Type { get; } = Type;
            }

            public record Property(string Name, Type DeclaringType, bool IsReactive, bool IsReadOnly, int DerivingIndex) : Bindable
            {
                // ReSharper disable once UnusedMember.Local
                public string Name { get; } = Name;

                // ReSharper disable once UnusedMember.Local
                public Type DeclaringType { get; } = DeclaringType;
                public bool IsReactive { get; } = IsReactive;
                public bool IsReadOnly { get; } = IsReadOnly;
                public int DerivingIndex { get; } = DerivingIndex;
            }
        }
    }
}