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

        private readonly ReactiveSource<T> _selection = new(null);

        private ReactiveSubscription _subscription;

        [UsedImplicitly]
        public Reactive<T> Selection => this._selection.Reactive;

        private void OnEnable()
        {
            this._subscription &= this.active.Reactive.DistinctUntilChanged().OnValue(this.OnActiveChanged);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnActiveChanged(int newValue)
        {
            if (newValue < 0 || newValue >= this.objects.Length)
            {
                newValue = this.fallbackActiveIndex;
            }

            for (int i = 0; i < this.objects.Length; i++)
            {
                bool isSelectedIndex = i == newValue;
                T obj = this.objects[i];

                this.OnSelectedStateChange(obj, isSelectedIndex);

                if (isSelectedIndex)
                {
                    this._selection.Value = obj;
                }
            }
        }

        protected abstract void OnSelectedStateChange(T obj, bool isSelected);
    }
}