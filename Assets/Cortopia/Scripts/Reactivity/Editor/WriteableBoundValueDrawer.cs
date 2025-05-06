// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Reactivity.Editor
{
    [CustomPropertyDrawer(typeof(WritableBoundValue<>))]
    public class WritableBoundValueDrawer : PropertyDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            float propertyHeight = base.GetPropertyHeight(property, label);
            return propertyHeight * 2;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.BeginProperty(position, label, property);

            SerializedProperty serializedReference = property.FindPropertyRelative("reference");
            SerializedProperty serializedPropertyName = property.FindPropertyRelative("propertyName");
            SerializedProperty serializedDefaultProperty = property.FindPropertyRelative("defaultValue");
            SerializedProperty debugProperty = property.FindPropertyRelative("breakOnChange");

            position.height /= 2;

            Rect debugPos = position;
            debugPos.y += position.height;
            debugPos.width = 110;

            EditorGUI.LabelField(position, label);
            float widthAdjustment = EditorGUIUtility.labelWidth + 2;
            position.width -= widthAdjustment;
            position.width /= property.hasMultipleDifferentValues ? 3 : 2;
            position.x += widthAdjustment;
            debugPos.x = position.x;

            var resultReference = default(Object);
            string resultPropertyName = "";

            Object reference = serializedReference.objectReferenceValue;
            string propertyName = serializedPropertyName.stringValue;

            EditorGUI.BeginChangeCheck();
            EditorGUI.BeginDisabledGroup(EditorApplication.isPlaying);

            Object pickedObj = EditorGUI.ObjectField(position, reference, typeof(Object), true);
            EditorGUI.EndDisabledGroup();
            bool referenceChanged = EditorGUI.EndChangeCheck();

            debugProperty.boolValue = GUI.Toggle(debugPos, debugProperty.boolValue, "Break on change", new GUIStyle("Button") {alignment = TextAnchor.MiddleCenter});

            if (EditorApplication.isPlaying)
            {
                EditorGUI.BeginDisabledGroup(true);
            }

            position.x += position.width;
            bool propertyNameChanged = false;

            if ((referenceChanged || !serializedReference.hasMultipleDifferentValues) && pickedObj)
            {
                var genericArguments = ReactiveDrawerHelpers.ParseField(property.serializedObject.targetObject.GetType(), property.propertyPath).GetGenericArguments();
                Type bindableType = typeof(IWritableBindableReactive<>).MakeGenericType(genericArguments);
                var monoBehaviours = pickedObj switch
                {
                    Component c => new[] {(Object) c.gameObject}.Concat(c.gameObject.GetComponents<Component>()),
                    GameObject go => new[] {pickedObj}.Concat(go.GetComponents<Component>()),
                    _ => new[] {pickedObj}
                };

                var bindings = monoBehaviours.SelectMany(obj =>
                    {
                        if (!obj)
                        {
                            return Enumerable.Empty<Bindable>();
                        }

                        Type objType = obj.GetType();
                        return objType.GetProperties()
                            .Select(p =>
                            {
                                bool canRead = p.CanRead && p.GetMethod.IsPublic;
                                if (!canRead)
                                {
                                    return null;
                                }

                                bool isReactive = bindableType.IsAssignableFrom(p.PropertyType);
                                bool isValid = isReactive || (genericArguments[0].IsAssignableFrom(p.PropertyType) && p.CanWrite && p.SetMethod.IsPublic);
                                // ReSharper disable once SuspiciousTypeConversion.Global
                                try
                                {
                                    string name = (obj as INamedBindableReactiveOwner)?.GetName(p.Name);
                                    if (string.IsNullOrWhiteSpace(name))
                                    {
                                        name = $"{obj.GetType().Name}.{p.Name}"; // Fallback to default Behavior.Property
                                    }

                                    return isValid ? new Bindable.Property(obj, p.Name, name, isReactive) : null;
                                }
                                catch (Exception)
                                {
                                    return null;
                                }
                            })
                            .Concat(bindableType.IsAssignableFrom(objType) ? new[] {new Bindable.Reference(obj)} : Enumerable.Empty<Bindable>())
                            .Where(b => b != null);
                    })
                    .OrderBy(b => b switch
                    {
                        Bindable.Reference => 0,
                        Bindable.Property p => p.IsReactive ? 1 : 2,
                        _ => throw new ArgumentOutOfRangeException(nameof(b), b, null)
                    })
                    .ToList();

                if (bindings.Count == 0)
                {
                    Debug.LogWarning($"Couldn't find any property with the type '{genericArguments.FirstOrDefault()}' in '{pickedObj}'.");
                }
                else
                {
                    int index = referenceChanged ? 0 :
                        pickedObj ? bindings.FindIndex(b => b switch
                        {
                            Bindable.Property p => p.Object == pickedObj && p.PropertyName == propertyName,
                            Bindable.Reference r => r.Object == pickedObj && string.IsNullOrEmpty(propertyName),
                            _ => throw new ArgumentOutOfRangeException(nameof(b))
                        }) : -1;

                    EditorGUI.BeginChangeCheck();

                    if (index < 0)
                    {
                        GUI.backgroundColor = Color.red;
                    }

                    index = EditorGUI.Popup(position, string.Empty, index, bindings.Select(BindableName).ToArray());
                    propertyNameChanged = EditorGUI.EndChangeCheck();

                    if (index >= 0)
                    {
                        (resultReference, resultPropertyName) = bindings[index] switch
                        {
                            Bindable.Property p => (p.Object, p.PropertyName),
                            Bindable.Reference r => (r.Object, null),
                            _ => throw new ArgumentOutOfRangeException()
                        };
                    }
                }
            }
            else if (property.hasMultipleDifferentValues)
            {
                position.x += position.width;
            }

            if (referenceChanged || propertyNameChanged)
            {
                serializedReference.objectReferenceValue = resultReference;
                serializedPropertyName.stringValue = resultPropertyName;
            }

            if ((!EditorApplication.isPlaying && serializedReference.objectReferenceValue == null) || property.hasMultipleDifferentValues)
            {
                try
                {
                    EditorGUI.PropertyField(position, serializedDefaultProperty, GUIContent.none); // Does its own change check
                }
                catch
                {
                    // We dont know what type the property is. PropertyField will fail if it has no drawer
                }
            }

            if (EditorApplication.isPlaying)
            {
                var boundValues = ReactiveDrawerHelpers.GetObjects<IWritableBoundValue>(property).ToArray();
                if (boundValues.Length == 0)
                {
                    EditorGUI.EndDisabledGroup();
                }

                position.y += position.height;

                foreach (IWritableBoundValue boundValue in boundValues)
                {
                    boundValue.SetCurrentValueAsDefault();
                }

                EditorGUI.BeginChangeCheck();
                try
                {
                    EditorGUI.PropertyField(position, serializedDefaultProperty, GUIContent.none); // Does its own change check
                }
                catch
                {
                    // We dont know what type the property is. PropertyField will fail if it has no drawer
                }

                if (EditorGUI.EndChangeCheck())
                {
                    property.serializedObject.ApplyModifiedProperties();
                    using (ReactiveTransaction.Create())
                    {
                        foreach (IWritableBoundValue boundValue in boundValues)
                        {
                            boundValue.ResetToDefaultValue();
                        }
                    }
                }

                if (boundValues.Length > 0)
                {
                    EditorGUI.EndDisabledGroup();
                }
            }

            EditorGUI.EndProperty();
        }

        private static string BindableName(Bindable bindable)
        {
            return bindable switch
            {
                Bindable.Property p => $"{(p.IsReactive ? "" : "[non-reactive] ")}{p.Name}",
                Bindable.Reference r => r.Object.GetType().Name,
                _ => throw new ArgumentOutOfRangeException()
            };
        }

        private abstract record Bindable
        {
            public record Reference(Object Object) : Bindable
            {
                public Object Object { get; } = Object;
            }

            public record Property(Object Object, string PropertyName, string Name, bool IsReactive) : Bindable
            {
                public Object Object { get; } = Object;
                public string PropertyName { get; } = PropertyName;
                public string Name { get; } = Name;
                public bool IsReactive { get; } = IsReactive;
            }
        }
    }
}