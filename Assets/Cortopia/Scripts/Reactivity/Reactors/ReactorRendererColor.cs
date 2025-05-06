// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Renderer))]
    public class ReactorRendererColor : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Color> color;

        private Renderer _renderer;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._renderer ??= this.GetComponent<Renderer>();
            this._subscription = this.color.Reactive.OnValue(c => this._renderer.material.color = c);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}