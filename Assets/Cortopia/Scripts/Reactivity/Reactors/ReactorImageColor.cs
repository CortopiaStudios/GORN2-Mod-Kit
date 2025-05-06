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
    public class ReactorImageColor : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Color> color;
        private bool _doSubscribe;
        private Image _image;
        private ReactiveSubscription _subscription;

        private void Start()
        {
            this._image = this.GetComponent<Image>();
        }

        private void Update()
        {
            if (!this._doSubscribe)
            {
                return;
            }

            this._doSubscribe = false;
            this._subscription = this.color.Reactive.OnValue(this.OnColorChange);
        }

        private void OnEnable()
        {
            this._doSubscribe = true;
        }

        private void OnDisable()
        {
            this._doSubscribe = false;
            this._subscription.Dispose();
        }

        private void OnColorChange(Color c)
        {
            this._image.color = c;
        }
    }
}