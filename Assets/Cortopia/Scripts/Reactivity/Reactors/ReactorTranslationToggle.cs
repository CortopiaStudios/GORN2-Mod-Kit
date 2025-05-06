// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorTranslationToggle : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> toggleValue;
        [SerializeField]
        private Vector3 truePosition;
        [SerializeField]
        private Vector3 falsePosition;
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;

        private readonly ReactiveSource<bool> _isMovingSource = new(false);

        private float _elapsedTime;
        private Vector3 _endPosition;
        private bool _isMoving;
        private Vector3 _startPosition;
        private ReactiveSubscription _subscription;
        private bool _toggleValue;

        [UsedImplicitly]
        public Reactive<bool> IsMoving => this._isMovingSource.Reactive;

        private void Awake()
        {
            this._toggleValue = this.toggleValue.Reactive.Value;

            Vector3 initialLocalPosition = this._toggleValue ? this.truePosition : this.falsePosition;
            Transform transform1 = this.transform;
            if (this.TryGetComponent(out Rigidbody rb))
            {
                // Initiate the physics position. Otherwise it will have one frame delay.
                rb.position = transform1.TransformPoint(initialLocalPosition);
                transform1.localPosition = initialLocalPosition;
            }
            else
            {
                transform1.localPosition = initialLocalPosition;
            }
        }

        private void Update()
        {
            if (!this._isMoving)
            {
                return;
            }

            if (this._elapsedTime > this.animationTime)
            {
                this._isMovingSource.Value = false;
                this._isMoving = false;
                return;
            }

            this._elapsedTime += Time.deltaTime;
            float delta = this.interpolationCurve.Evaluate(this._elapsedTime / this.animationTime);
            this.transform.localPosition = Vector3.LerpUnclamped(this._startPosition, this._endPosition, delta);
        }

        private void OnEnable()
        {
            this._startPosition = this.transform.localPosition;
            this._subscription = this.toggleValue.Reactive.OnValue(this.TryTogglePosition);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void TryTogglePosition(bool value)
        {
            if (this._toggleValue == value)
            {
                return;
            }

            this._toggleValue = value;
            this._endPosition = value ? this.truePosition : this.falsePosition;
            this._startPosition = this.transform.localPosition;
            this._elapsedTime = 0f;
            this._isMoving = true;
            this._isMovingSource.Value = true;
        }
    }
}