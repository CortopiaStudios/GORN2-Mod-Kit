// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorRotationSwitch : MonoBehaviour
    {
        [Header("Reactive")]
        [SerializeField]
        private BoundValue<int> switchValue;

        [Header("Rotation Settings")]
        [SerializeField]
        private Vector3[] switchTargetRotations;

        [Header("Animation Settings")]
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;
        [SerializeField]
        private float delayTime;

        private readonly ReactiveSource<IntegerCounter> _animationCounter = new(new IntegerCounter());

        private float _elapsedTime;
        private Quaternion _endRotation;
        private Quaternion _startRotation;
        private State _state = State.Idle;
        private ReactiveSubscription _subscription;
        private int _visualSwitchValue;

        [UsedImplicitly]
        public Reactive<IntegerCounter> AnimationCounter => this._animationCounter.Reactive.DistinctUntilChanged();

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
            this._subscription = this.switchValue.Reactive.DistinctUntilChanged().OnValue(this.Handler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Handler(int value)
        {
            if (this._visualSwitchValue == value)
            {
                return;
            }

            if (value < 0)
            {
                value = 0;
            }
            else if (value >= this.switchTargetRotations.Length)
            {
                value = this.switchTargetRotations.Length - 1;
            }

            this._visualSwitchValue = value;
            this._startRotation = this.transform.localRotation;
            this._endRotation = Quaternion.Euler(this.switchTargetRotations[value]);
            this._elapsedTime = 0f;

            if (this._startRotation == this._endRotation)
            {
                this.SetState(State.Idle);
            }
            else
            {
                this._animationCounter.Value = this._animationCounter.Value.Incremented;
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
        }

        private enum State
        {
            Idle,
            Delaying,
            Animating
        }
    }
}