// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorConditionalTranslator : MonoBehaviour
    {
        [Header("Sources")]
        [SerializeField]
        private BoundValue<float> normalizedValue;
        [SerializeField]
        private BoundValue<bool> isConnectionActive;
        [Header("Settings")]
        [SerializeField]
        private Vector3 targetLocalPosition;
        [SerializeField]
        private Vector3 startPosition;
        [SerializeField]
        private Vector3 endPosition;
        [SerializeField]
        private float targetDistanceThreshold;

        private readonly ReactiveSource<bool> _isActive = new(false);
        private readonly ReactiveSource<bool> _isCorrectPosition = new(false);

        private float _savedDelta;
        private float _startingNormalizedValue;
        private ReactiveSubscription _subscription;

        [UsedImplicitly]
        public Reactive<bool> IsActive => this._isActive.Reactive;

        [UsedImplicitly]
        public Reactive<bool> IsCorrectPosition => this._isCorrectPosition.Reactive;

        private void OnEnable()
        {
            this._subscription = this.isConnectionActive.Reactive.Combine(this.normalizedValue.Reactive).OnValue(this.Handler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Handler((bool isActive, float normalizedFloat) obj)
        {
            if (!obj.isActive)
            {
                if (this._isActive.Value)
                {
                    this._savedDelta += obj.normalizedFloat - this._startingNormalizedValue;
                    this._savedDelta = Mathf.Clamp01(this._savedDelta);
                }

                this._isActive.Value = false;
                return;
            }

            if (!this._isActive.Value)
            {
                this._startingNormalizedValue = obj.normalizedFloat;
                this._isActive.Value = true;
            }

            float delta = obj.normalizedFloat - this._startingNormalizedValue;
            Vector3 newLocalPosition = Vector3.Lerp(this.startPosition, this.endPosition, this._savedDelta + delta);

            this._isCorrectPosition.Value = Vector3.Distance(newLocalPosition, this.targetLocalPosition) < this.targetDistanceThreshold;
            this.transform.localPosition = this._isCorrectPosition.Value ? this.targetLocalPosition : newLocalPosition;
        }
    }
}