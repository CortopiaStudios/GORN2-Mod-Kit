// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Serialization;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveGameObjectBool : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [FormerlySerializedAs("gameObjectValue")]
        [SerializeField]
        private new BoundValue<GameObject> gameObject;

        [UsedImplicitly]
        public Reactive<bool> HasValue => this.gameObject.Reactive.Select(go => go != null);
        
        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : propertyName == nameof(this.HasValue) ? this.reactiveName : $"{this.reactiveName}.{propertyName}";
        }
    }
}