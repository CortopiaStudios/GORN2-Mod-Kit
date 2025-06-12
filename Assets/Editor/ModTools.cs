using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using Cortopia.Scripts.Core.Spawn;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Build;
using UnityEditor.AddressableAssets.Settings;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Editor
{
    public static class ModTools
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

            // Save changes back to the prefab asset
            PrefabUtility.SaveAsPrefabAsset(prefabRoot, assetPath);

            // Unload the temporary prefab contents from memory
            PrefabUtility.UnloadPrefabContents(prefabRoot);
        }

        [MenuItem("Mod Tools/Build")]
        public static void BuildAddressablesDefault()
        {
            var settings = AddressableAssetSettingsDefaultObject.Settings;
            if (!settings)
            {
                Debug.LogError("Addressable settings not found.");
                return;
            }

            // Get the default build script from the active profile
            var builder = settings.ActivePlayerDataBuilder;

            // Build content using the current settings and active builder
            var result = builder.BuildData<AddressableAssetBuildResult>(new AddressablesDataBuilderInput(settings));

            if (result != null && string.IsNullOrEmpty(result.Error))
            {
                Debug.Log("Addressables build completed successfully.");
            }
            else
            {
                Debug.LogError("Addressables build failed: " + result?.Error);
                return;
            }

            // Get the resolved build path from the profile
            var buildPath = settings.profileSettings
                .EvaluateString(settings.activeProfileId, $"[{AddressableAssetSettings.kRemoteBuildPath}]");
            var platformName = EditorUserBuildSettings.activeBuildTarget.ToString();

            // Resolve [BuildTarget] manually if not already replaced
            if (buildPath.Contains("[BuildTarget]")) buildPath = buildPath.Replace("[BuildTarget]", platformName);

            var fullPath = Path.GetFullPath(buildPath);
            var modFiles = result.FileRegistry.GetFilePaths().Where(x => IsPathInDirectory(x, fullPath)).ToList();
            var zipFilePath = $"{fullPath}/{DateTime.Now.ToFileTime()}.zip";

            CreateZipFromFiles(modFiles, zipFilePath);

            var uriPath = "file:///" + zipFilePath.Replace("\\", "/");
            Debug.Log($"Zip file created: <a href=\"{uriPath}\" line=\"2\">{zipFilePath}</a>");

            foreach (var modFile in modFiles) File.Delete(modFile);
        }

        private static bool IsPathInDirectory(string filePath, string directoryPath)
        {
            var fileFullPath = Path.GetFullPath(filePath)
                .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
            var dirFullPath = Path.GetFullPath(directoryPath)
                .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

            return fileFullPath.StartsWith(dirFullPath + Path.DirectorySeparatorChar);
        }

        private static void CreateZipFromFiles(IEnumerable<string> filePaths, string zipFilePath)
        {
            // Ensure the target zip does not exist before creating it
            if (File.Exists(zipFilePath)) File.Delete(zipFilePath);

            using var zipToCreate = new FileStream(zipFilePath, FileMode.Create);
            using var archive = new ZipArchive(zipToCreate, ZipArchiveMode.Create);
            foreach (var filePath in filePaths)
                if (File.Exists(filePath))
                {
                    // Get file name only to store in zip (not full path)
                    var entryName = Path.GetFileName(filePath);
                    archive.CreateEntryFromFile(filePath, entryName);
                }
                else
                {
                    Debug.Log($"Warning: File not found - {filePath}");
                }
        }
    }
}