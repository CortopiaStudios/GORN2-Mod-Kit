// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Animator))]
    public class ReactorAnimatorBool : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> boolValue;
        [SerializeField]
        private string parameterName = "IsActive";

        private Animator _animator;
        private int? _parameterHash;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._animator ??= this.GetComponent<Animator>();
            this._parameterHash ??= Animator.StringToHash(this.parameterName);
            this._subscription = this.boolValue.Reactive.OnValue(b => this._animator.SetBool(this._parameterHash.Value, b));
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}