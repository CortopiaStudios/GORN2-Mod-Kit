// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.UI;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Slider))]
    public class ReactorSlider : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> value;

        private Slider _slider;
        private ReactiveSubscription _subscription;

        private void Awake()
        {
            this._slider = this.GetComponent<Slider>();
        }

        private void OnEnable()
        {
            this._subscription = this.value.Reactive.OnValue(x => this._slider.value = x);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}