// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine.Profiling;

namespace Cortopia.Scripts.Reactivity.Utils
{
    public interface IEditorPlayModeStateChanged
    {
        void EditorOnPlayModeStateChanged(PlayModeStateChange state);
    }

    // This class is used as a middleman when listening to 'EditorApplication.playModeStateChanged' to improve the performance.
    public static class LightweightEditorApplication
    {
        private static readonly List<IEditorPlayModeStateChanged> Listeners = new(100);

        [InitializeOnLoadMethod]
        private static void Initialize()
        {
            EditorApplication.playModeStateChanged += OnPlayModeStateChanged;
        }

        public static void AddListener(IEditorPlayModeStateChanged listener)
        {
            Profiler.BeginSample("EditorOnly [LightweightEditorApplication.AddListener(..)]");

            if (!Listeners.Contains(listener))
            {
                Listeners.Add(listener);
            }

            Profiler.EndSample();
        }

        private static void OnPlayModeStateChanged(PlayModeStateChange state)
        {
            foreach (IEditorPlayModeStateChanged listener in Listeners)
            {
                listener.EditorOnPlayModeStateChanged(state);
            }
        }
    }
}
#endif