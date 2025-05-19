using Cortopia.Scripts.Core.Spawn;
using UnityEditor;
using UnityEngine;

public static class ModBuilder
{
    [MenuItem("CONTEXT/Transform/Cleanup prefab", false, 0)]
    public static void CleanupPrefab(MenuCommand command)
    {
        var go = ((Transform) command.context).gameObject;

        GameObjectUtility.RemoveMonoBehavioursWithMissingScript(go);

        foreach (var component in go.GetComponents<Component>())
        {
            if (component is SpawnerParameter)
                continue;

            Object.DestroyImmediate(component);
        }

        foreach (var parameter in go.GetComponents<SpawnerParameter>())
        {
            var serializedObject = new SerializedObject(parameter);
            serializedObject.Update();

            var boundValue = serializedObject.FindProperty("boundValue");
            var reference = boundValue.FindPropertyRelative("reference");
            var defaultValue = boundValue.FindPropertyRelative("defaultValue");

            reference.objectReferenceValue = null;
            if (defaultValue.objectReferenceValue)
                defaultValue.objectReferenceValue = null;

            serializedObject.ApplyModifiedProperties();
        }

        while (go.transform.childCount > 0) Object.DestroyImmediate(go.transform.GetChild(0).gameObject);

        EditorUtility.SetDirty(go);
    }
}