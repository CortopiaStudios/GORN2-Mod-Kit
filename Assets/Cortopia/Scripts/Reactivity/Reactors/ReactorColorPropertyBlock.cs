// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Renderer))]
    public class ReactorColorPropertyBlock : MonoBehaviour
    {
        private static readonly int ColorProperty = Shader.PropertyToID("_ColorProperty");

        [SerializeField]
        private BoundValue<Color> materialColor;

        private Renderer _cachedRenderer;
        // The material property block we pass to the GPU
        private MaterialPropertyBlock _propertyBlock;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.materialColor.Reactive.OnValue(this.SetColorProperty);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

#if UNITY_EDITOR
        private void OnValidate()
        {
            if (this.materialColor != null)
            {
                this.SetColorProperty(this.materialColor.EditorDefaultValue);
            }
        }
#endif

        private void SetColorProperty(Color color)
        {
            // Create property block only if none exists
            this._propertyBlock ??= new MaterialPropertyBlock();
            // Set the color property
            this._propertyBlock.SetColor(ColorProperty, color);
            // Apply property block to renderer
            this._cachedRenderer ??= this.GetComponent<Renderer>();

            if (!this._cachedRenderer)
            {
                Debug.LogError("No Renderer found, it is required for this component", this);
                return;
            }

            this._cachedRenderer.SetPropertyBlock(this._propertyBlock);
        }
    }
}