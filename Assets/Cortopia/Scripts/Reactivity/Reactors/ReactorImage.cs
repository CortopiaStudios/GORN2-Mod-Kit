// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.UI;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Image))]
    public class ReactorImage : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Sprite> image;

        private Image _image;
        private ReactiveSubscription _subscription;

        private void Awake()
        {
            this._image = this.GetComponent<Image>();
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
            this._image.sprite = newSprite;
            this._image.enabled = newSprite;
        }
    }
}