// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorScaler : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;
        [SerializeField]
        private bool isLooping;
        [SerializeField]
        private Vector3 startScale;
        [SerializeField]
        private Vector3 endScale;
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;
        
        private float _elapsedTime;
        private ReactiveSubscription _subscription;
        private bool _isActive;

        private void OnEnable()
        {
            this._subscription = this.isActive.Reactive.OnValue(x => this._isActive = x);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Update()
        {
            if (!this._isActive)
            {
                return;
            }
            
            if (this._elapsedTime > this.animationTime)
            {
                if (!this.isLooping)
                {
                    return;
                }

                this._elapsedTime -= this.animationTime;
            }

            this._elapsedTime += Time.deltaTime;
            float delta = this.interpolationCurve.Evaluate(this._elapsedTime / this.animationTime);
            this.transform.localScale = Vector3.Lerp(this.startScale, this.endScale, delta);
        }
    }
}