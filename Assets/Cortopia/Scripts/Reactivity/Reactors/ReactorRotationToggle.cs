// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorRotationToggle : MonoBehaviour
    {
        [Header("Reactive")]
        [SerializeField]
        private BoundValue<bool> toggleValue;
        
        [Header("Rotation Settings")]
        [SerializeField]
        private Vector3 falseRotation;
        [SerializeField]
        private Vector3 trueRotation;
        
        [Header("Animation Settings")]
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;
        [SerializeField]
        private float delayTime;

        private readonly ReactiveSource<bool> _isAnimating = new(false);

        private float _elapsedTime;
        private Quaternion _endRotation;
        private Quaternion _startRotation;
        private State _state = State.Idle;
        private ReactiveSubscription _subscription;
        private bool _visualToggleValue;

        [UsedImplicitly]
        public Reactive<bool> IsTogglingTrue => this._isAnimating.Reactive.Combine(this.toggleValue.Reactive).Select((b1, b2) => b1 && b2);

        [UsedImplicitly]
        public Reactive<bool> IsTogglingFalse => this._isAnimating.Reactive.Combine(this.toggleValue.Reactive).Select((b1, b2) => b1 && !b2);

        private void Update()
        {
            switch (this._state)
            {
                case State.Idle:
                    break;
                case State.Delaying:
                    this.Delay();
                    break;
                case State.Animating:
                    this.Animate();
                    break;
            }
        }

        private void OnEnable()
        {
            this._subscription = this.toggleValue.Reactive.DistinctUntilChanged().OnValue(this.Handler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Handler(bool value)
        {
            if (this._visualToggleValue == value)
            {
                return;
            }

            this._visualToggleValue = value;
            this._startRotation = this.transform.localRotation;
            this._endRotation = value ? Quaternion.Euler(this.trueRotation) : Quaternion.Euler(this.falseRotation);
            this._elapsedTime = 0f;

            if (this._startRotation == this._endRotation)
            {
                this.SetState(State.Idle);
            }
            else
            {
                this.SetState(this.delayTime > 0f ? State.Delaying : State.Animating);
            }
        }

        private void Delay()
        {
            if (this._elapsedTime > this.delayTime)
            {
                this._elapsedTime = 0f;
                this.SetState(State.Animating);
                return;
            }

            this._elapsedTime += Time.deltaTime;
        }

        private void Animate()
        {
            if (this._elapsedTime > this.animationTime)
            {
                this.SetState(State.Idle);
                return;
            }

            this._elapsedTime += Time.deltaTime;
            float delta = this.interpolationCurve.Evaluate(this._elapsedTime / this.animationTime);
            this.transform.localRotation = Quaternion.Lerp(this._startRotation, this._endRotation, delta);
        }

        private void SetState(State state)
        {
            this._state = state;
            this._isAnimating.Value = state == State.Animating;
        }

        [ContextMenu("Set True Rotation")]
        private void SetToTrueRotation()
        {
            this.transform.localRotation = Quaternion.Euler(this.trueRotation);
        }

        [ContextMenu("Set False Rotation")]
        private void SetToFalseRotation()
        {
            this.transform.localRotation = Quaternion.Euler(this.falseRotation);
        }

        private enum State
        {
            Idle,
            Delaying,
            Animating
        }
    }
}