// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(SpriteRenderer))]
    public class ReactorSpriteRenderer : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Sprite> image;

        private Vector2 _originalSize;
        private SpriteRenderer _spriteRenderer;
        private ReactiveSubscription _subscription;

        private void Awake()
        {
            this._spriteRenderer = this.GetComponent<SpriteRenderer>();
            this._originalSize = this._spriteRenderer.size;
        }

        private void OnEnable()
        {
            this._subscription = this.image.Reactive.OnValue(this.OnSpriteChange);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnSpriteChange(Sprite newSprite)
        {
            this._spriteRenderer.sprite = newSprite;
            this._spriteRenderer.enabled = newSprite;
            this._spriteRenderer.size = this._originalSize;
        }
    }
}