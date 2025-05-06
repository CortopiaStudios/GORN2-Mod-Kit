// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorScaleToggle : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> toggleValue;
        [SerializeField]
        private Vector3 trueScale;
        [SerializeField]
        private Vector3 falseScale;
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;

        private float _elapsedTime;
        private Vector3 _startingScale;

        private ReactiveSubscription _subscription;
        private bool _visualToggleValue;

        private void Update()
        {
            if (this._elapsedTime > this.animationTime)
            {
                return;
            }

            Vector3 targetScale = this._visualToggleValue ? this.trueScale : this.falseScale;

            this._elapsedTime += Time.deltaTime;
            float delta = this.interpolationCurve.Evaluate(this._elapsedTime / this.animationTime);

            this.transform.localScale = Vector3.LerpUnclamped(this._startingScale, targetScale, delta);
        }

        private void OnEnable()
        {
            this._startingScale = this.transform.localScale;
            this._subscription = this.toggleValue.Reactive.OnValue(this.Handler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Handler(bool obj)
        {
            if (this._visualToggleValue == obj)
            {
                return;
            }

            this._startingScale = this.transform.localScale;
            this._elapsedTime = 0f;
            this._visualToggleValue = obj;
        }

        [ContextMenu("Set True Position")]
        private void SetToTrueTranslation()
        {
            this.transform.localScale = this.trueScale;
        }

        [ContextMenu("Set False Position")]
        private void SetToFalsePosition()
        {
            this.transform.localScale = this.falseScale;
        }
    }
}