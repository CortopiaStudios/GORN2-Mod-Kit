// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(Animator))]
    public class ReactorAnimatorTrigger : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> triggerSource;
        [SerializeField]
        private string triggerParameterName;

        private Animator _animator;
        private ReactiveSubscription _subscription;
        private int _triggerHash;

        private void Awake()
        {
            this._triggerHash = Animator.StringToHash(this.triggerParameterName);
            this._animator ??= this.GetComponent<Animator>();
        }

        private void OnEnable()
        {
            this._subscription = this.triggerSource.Reactive.OnValue(this.TriggerHandler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void TriggerHandler(bool newValue)
        {
            if (newValue)
            {
                this._animator.SetTrigger(this._triggerHash);
            }
        }
    }
}