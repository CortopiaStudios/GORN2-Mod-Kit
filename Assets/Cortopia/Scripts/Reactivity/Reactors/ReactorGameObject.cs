// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorGameObject : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> active;
        [SerializeField]
        private new GameObject gameObject;
        [SerializeField]
        private bool inverseBoundRelation;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.active.Reactive.OnValueWithState(this, static (s, x) => s.OnActiveChanged(x));
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnActiveChanged(bool isActive)
        {
            if (!this.gameObject)
            {
                Debug.LogError($"{nameof(this.gameObject)} was null when {nameof(this.active)} was changed in {nameof(ReactorGameObject)}", this);
                return;
            }

            this.gameObject.SetActive(isActive ^ this.inverseBoundRelation);
        }
    }
}