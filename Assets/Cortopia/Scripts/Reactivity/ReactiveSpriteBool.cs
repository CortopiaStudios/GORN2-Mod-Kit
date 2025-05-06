// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveSpriteBool : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> valueSwitch;
        [SerializeField]
        private Sprite falseSprite;
        [SerializeField]
        private Sprite trueSprite;

        private readonly ReactiveSource<Sprite> _sprite = new(null);

        private ReactiveSubscription _subscription;

        [UsedImplicitly]
        public Reactive<Sprite> Sprite => this._sprite.Reactive;

        private void OnEnable()
        {
            this._subscription = this.valueSwitch.Reactive.DistinctUntilChanged().OnValue(active => { this._sprite.Value = active ? this.trueSprite : this.falseSprite; });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}