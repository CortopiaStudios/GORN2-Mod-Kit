// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Animator))]
    public class ReactorAnimatorFloat : MonoBehaviour
    {
        [SerializeField]
        private string valueName;
        
        [SerializeField]
        private BoundValue<float> floatValue;

        private Animator _animator;

        private ReactiveSubscription _subscription;

        private int _nameHash;

        private void OnEnable()
        {
            this._nameHash = Animator.StringToHash(this.valueName);
            this._animator ??= this.GetComponent<Animator>();
            this._subscription = this.floatValue.Reactive.OnValue(x =>
            {
                this._animator.SetFloat(this._nameHash, x);
            });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}