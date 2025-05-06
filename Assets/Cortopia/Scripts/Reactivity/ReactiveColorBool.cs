// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveColorBool : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> valueSwitch;
        [SerializeField]
        private BoundValue<Color> falseColor = new(UnityEngine.Color.red);
        [SerializeField]
        private BoundValue<Color> trueColor = new(UnityEngine.Color.green);

        private readonly ReactiveSource<Color> _color = new(UnityEngine.Color.white);
        private ReactiveSubscription _subscription;

        [UsedImplicitly]
        public Reactive<Color> Color => this._color.Reactive;

        private void OnEnable()
        {
            this._subscription = this.valueSwitch.Reactive.DistinctUntilChanged()
                .Combine(this.trueColor.Reactive, this.falseColor.Reactive)
                .OnValue(values =>
                {
                    (bool active, Color aColor, Color iColor) = values;
                    this._color.Value = active ? aColor : iColor;
                });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}