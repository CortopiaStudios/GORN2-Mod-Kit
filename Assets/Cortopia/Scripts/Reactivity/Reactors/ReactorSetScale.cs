// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorSetScale : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Vector3> scale;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription &= this.scale.Reactive.OnValue(s => this.transform.localScale = s);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}