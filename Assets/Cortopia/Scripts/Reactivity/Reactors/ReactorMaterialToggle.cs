// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Renderer))]
    public class ReactorMaterialToggle : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;
        [Header("Settings")]
        [SerializeField]
        private int materialIndex = -1;
        [SerializeField]
        private Material trueMaterial;
        [SerializeField]
        private Material falseMaterial;

        private Renderer _renderer;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.isActive.Reactive.OnValue(this.Handler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Handler(bool obj)
        {
            this._renderer ??= this.GetComponent<Renderer>();
            var cachedMaterials = this._renderer.materials;
            Material targetMaterial = obj ? this.trueMaterial : this.falseMaterial;

            if (this.materialIndex == -1)
            {
                for (int i = 0; i < cachedMaterials.Length; i++)
                {
                    cachedMaterials[i] = targetMaterial;
                }
            }
            else
            {
                if (cachedMaterials.Length > this.materialIndex)
                {
                    cachedMaterials[this.materialIndex] = targetMaterial;
                }
                else
                {
                    Debug.LogWarning($"Renderer on object doesn't have material index {this.materialIndex}", this);
                }
            }

            this._renderer.materials = cachedMaterials;
        }
    }
}