// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [Obsolete("Use ReactorBehaviour instead")]
    public class ReactorMonoBehaviour : MonoBehaviour
    {
        [SerializeField]
        private new BoundValue<bool> enabled;
        [SerializeField]
        private MonoBehaviour monoBehaviour;
        [SerializeField]
        private bool inverseBoundRelation;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.enabled.Reactive.OnValue(this.OnActiveChanged);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnActiveChanged(bool isActive)
        {
            if (this.monoBehaviour)
            {
                this.monoBehaviour.enabled = isActive ^ this.inverseBoundRelation;
            }
        }
    }
}