// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Debugging
{
    internal class ReactiveStringDebug : MonoBehaviour
    {
        [SerializeField]
        private string message;

        [SerializeField]
        private BoundValue<string> value;

#if UNITY_EDITOR
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription &= this.value.Reactive.OnValue(v => Debug.Log($"{nameof(ReactiveStringDebug)} ({this.gameObject.name}) {this.message}: {v}"));
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
#endif
    }
}