using System.Collections.Generic;
using Cortopia.Scripts.Core.Spawn;
using UnityEditor;
using UnityEngine;

public static class ModBuilder
{
    [MenuItem("CONTEXT/Transform/Cleanup prefab", false, 0)]
    public static void CleanupPrefab(MenuCommand command)
    {
        // Load the prefab contents into a temporary GameObject
        var assetPath = AssetDatabase.GetAssetPath(command.context);
        var prefabRoot = PrefabUtility.LoadPrefabContents(assetPath);

        GameObjectUtility.RemoveMonoBehavioursWithMissingScript(prefabRoot);

        foreach (var component in prefabRoot.GetComponents<Component>())
        {
            if (component is SpawnerParameter)
                continue;

            Object.DestroyImmediate(component);
        }

        GameObjectUtility.RemoveMonoBehavioursWithMissingScript(prefabRoot);

        foreach (var parameter in prefabRoot.GetComponents<SpawnerParameter>())
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

        var children = new List<GameObject>();
        for (var i = 0; i < prefabRoot.transform.childCount; i++)
            children.Add(prefabRoot.transform.GetChild(i).gameObject);

        foreach (var child in children)
            Object.DestroyImmediate(child);

        // EditorUtility.SetDirty(prefabRoot);
        
        // Save changes back to the prefab asset
        PrefabUtility.SaveAsPrefabAsset(prefabRoot, assetPath);

        // Unload the temporary prefab contents from memory
        PrefabUtility.UnloadPrefabContents(prefabRoot);
    }
}