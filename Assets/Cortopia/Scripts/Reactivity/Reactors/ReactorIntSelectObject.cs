// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public abstract class ReactorIntSelectObject<T> : MonoBehaviour where T : Object
    {
        [SerializeField]
        private BoundValue<int> active;

        [SerializeField]
        [Tooltip("Index to use if the BoundValue index were to return an invalid integer.")]
        private int fallbackActiveIndex;

        [Space]
        [SerializeField]
        private T[] objects;

        [UsedImplicitly]
        public Reactive<T> Selection => new();

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }

        protected abstract void OnSelectedStateChange(T obj, bool isSelected);
    }
}