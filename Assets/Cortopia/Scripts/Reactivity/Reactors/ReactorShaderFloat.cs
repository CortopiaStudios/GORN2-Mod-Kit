// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Renderer))]
    public class ReactorShaderFloat : MonoBehaviour
    {
        [SerializeField]
        private string shaderPropertyName;
        [SerializeField]
        private int materialSubIndex;
        [SerializeField]
        private BoundValue<float> value;

        private Renderer _renderer;
        private int _shaderProperty;
        private ReactiveSubscription _subscribe;

        private void Awake()
        {
            this._shaderProperty = Shader.PropertyToID(this.shaderPropertyName);
            this._renderer = this.GetComponent<Renderer>();
        }

        private void OnEnable()
        {
            this._subscribe &= this.value.Reactive.OnValue(f => this._renderer.materials[this.materialSubIndex].SetFloat(this._shaderProperty, f));
        }

        private void OnDisable()
        {
            this._subscribe.Dispose();
        }
    }
}