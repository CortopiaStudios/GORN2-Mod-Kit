// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEditor;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    public static class VertexAnimationAssetDatabaseUtils
    {
        public static bool GetChildAssetOfType<T>(Object parent, out T childAsset) where T : Object
        {
            var assets = AssetDatabase.LoadAllAssetsAtPath(AssetDatabase.GetAssetPath(parent));

            foreach (Object asset in assets)
            {
                if (asset is not T t)
                {
                    continue;
                }

                childAsset = t;
                return true;
            }

            childAsset = null;
            return false;
        }

        public static void RemoveChildAssets(Object parent, Predicate<Object> filter = null)
        {
            var assets = AssetDatabase.LoadAllAssetsAtPath(AssetDatabase.GetAssetPath(parent));

            foreach (Object asset in assets)
            {
                if (asset == parent)
                {
                    continue;
                }

                bool keep = filter == null || filter(asset);
                if (!keep)
                {
                    AssetDatabase.RemoveObjectFromAsset(asset);
                }
            }
        }

        public static bool HasAsset(string path, Type type)
        {
            return AssetDatabase.LoadAssetAtPath(path, type);
        }
    }
}