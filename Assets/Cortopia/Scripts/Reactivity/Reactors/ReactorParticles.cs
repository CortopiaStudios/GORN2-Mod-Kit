// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(ParticleSystem))]
    public class ReactorParticles : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;
        [SerializeField]
        private bool withChildren;

        private ParticleSystem _particleSystem;
        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._particleSystem ??= this.GetComponent<ParticleSystem>();
            this.isActive.Reactive.OnValue(x =>
            {
                if (x)
                {
                    this._particleSystem.Play(this.withChildren);
                }
                else
                {
                    this._particleSystem.Stop();
                }
            });
        }
    }
}