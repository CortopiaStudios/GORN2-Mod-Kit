// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Events
{
    public abstract class EventPassthrough<T> : ScriptableObject
    {
        // ReSharper disable once Unity.RedundantEventFunction
        private void OnEnable()
        {
        }

        // ReSharper disable once Unity.RedundantEventFunction
        private void OnDisable()
        {
        }

        // ReSharper disable once UnusedMember.Global
        public void Invoke(T value)
        {
        }

        // ReSharper disable once UnusedMember.Global
        public void AddListener(UnityAction<T> action)
        {
        }

        // ReSharper disable once UnusedMember.Global
        public void RemoveListener(UnityAction<T> action)
        {
        }
    }
}