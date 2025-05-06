// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Rigidbody))]
    public class ReactorRigidbody : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> useGravity;
        [SerializeField]
        private BoundValue<bool> isKinematic;

        private Rigidbody _rigidbody;
        private ReactiveSubscription _subscription;

        private void Awake()
        {
            this._rigidbody = this.GetComponent<Rigidbody>();
        }

        private void OnEnable()
        {
            this._subscription &= this.useGravity.Reactive.OnValue(b => this._rigidbody.useGravity = b);
            this._subscription &= this.isKinematic.Reactive.OnValue(b => this._rigidbody.isKinematic = b);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}