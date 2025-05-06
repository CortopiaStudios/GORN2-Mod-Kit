// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Reactivity.Editor
{
    public static class ReactiveDrawerHelpers
    {
        public static IEnumerable<T> GetObjects<T>(SerializedProperty property)
        {
            SerializedObject serializedObject = property?.serializedObject;
            if (serializedObject == null)
            {
                yield break;
            }

            var slicedName = property.propertyPath.Split('.').ToList();
            var arrayCounts = new List<int>();
            for (int index = 0; index < slicedName.Count; index++)
            {
                arrayCounts.Add(-1);
                string currName = slicedName[index];
                if (currName.EndsWith("]"))
                {
                    string[] arraySlice = currName.Split('[', ']');
                    if (arraySlice.Length >= 2)
                    {
                        arrayCounts[index - 2] = Convert.ToInt32(arraySlice[1]);
                        slicedName[index] = string.Empty;
                        slicedName[index - 1] = string.Empty;
                    }
                }
            }

            while (string.IsNullOrEmpty(slicedName.Last()))
            {
                int i = slicedName.Count - 1;
                slicedName.RemoveAt(i);
                arrayCounts.RemoveAt(i);
            }

            foreach (Object targetObject in serializedObject.targetObjects)
            {
                object obj = targetObject;
                for (int depth = 0; depth < slicedName.Count; depth++)
                {
                    string currName1 = slicedName[depth];

                    if (string.IsNullOrEmpty(currName1))
                    {
                        continue;
                    }

                    int arrayIndex = arrayCounts[depth];

                    FieldInfo newField = obj.GetType().GetField(currName1, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

                    if (newField == null)
                    {
                        Type baseType = obj.GetType().BaseType;
                        while (baseType != null && newField == null)
                        {
                            newField = baseType.GetField(currName1, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                            baseType = baseType.BaseType;
                        }

                        if (newField == null)
                        {
                            break;
                        }
                    }

                    obj = newField.GetValue(obj);
                    if (depth == slicedName.Count - 1)
                    {
                        if (arrayIndex < 0)
                        {
                            yield return (T) obj;
                        }

                        else if (obj is IList newObjList && newObjList.Count > arrayIndex)
                        {
                            yield return (T) newObjList[arrayIndex];
                        }

                        break;
                    }

                    if (arrayIndex >= 0 && obj is IList list)
                    {
                        obj = list[arrayIndex];
                    }
                }
            }
        }

        public static Type ParseField(Type type, string propertyPath)
        {
            if (GetArrayOrListElementType(type) is { } listElementType)
            {
                int endBracket = propertyPath.IndexOf("].", StringComparison.Ordinal);
                return endBracket < 0 ? listElementType : ParseField(listElementType, propertyPath.Substring(endBracket + 2));
            }

            int dot = propertyPath.IndexOf(".", StringComparison.Ordinal);
            if (dot < 0)
            {
                return GetFieldType(type, propertyPath);
            }

            return ParseField(GetFieldType(type, propertyPath.Substring(0, dot)), propertyPath.Substring(dot + 1));
        }

        private static Type GetFieldType(Type type, string propertyPath)
        {
            while (type != null)
            {
                FieldInfo field = type.GetField(propertyPath, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
                if (field != null && (field.IsPublic || field.CustomAttributes.Any(x => x.AttributeType == typeof(SerializeField))))
                {
                    return field.FieldType;
                }

                type = type.BaseType;
            }

            return null;
        }

        private static Type GetArrayOrListElementType(Type listType)
        {
            if (listType.IsArray)
            {
                return listType.GetElementType();
            }

            if (listType.IsGenericType && listType.GetGenericTypeDefinition() == typeof(List<>))
            {
                return listType.GetGenericArguments()[0];
            }

            return null;
        }
    }
}