// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.References
{
    public abstract class ReactiveRef<T> : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        private BoundValue<T> value;

        [UsedImplicitly]
        public Reactive<T> Value => this.value.Reactive;
        
        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : propertyName == nameof(this.Value) ? this.reactiveName : $"{this.reactiveName}.{propertyName}";
        }
    }
}