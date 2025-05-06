// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorConditionalRotator : MonoBehaviour
    {
        [Header("Sources")]
        [SerializeField]
        private BoundValue<float> normalizedValue;
        [SerializeField]
        private BoundValue<bool> isConnectionActive;
        [Header("Settings")]
        [SerializeField]
        private Axis rotationAxis;
        [SerializeField]
        private float rotationAngle;
        [SerializeField]
        private float snappingRotationAngle;
        [SerializeField]
        private float snappingThreshold;

        private readonly ReactiveSource<bool> _isActive = new(false);
        private readonly ReactiveSource<bool> _isCorrectAngle = new(false);

        private Quaternion _offsetValue;
        private float _startingNormalizedValue;
        private ReactiveSubscription _subscription;
        private Vector3 _targetForward;

        [UsedImplicitly]
        public Reactive<bool> IsActive => this._isActive.Reactive;

        [UsedImplicitly]
        public Reactive<bool> IsCorrectAngle => this._isCorrectAngle.Reactive;

        private void OnEnable()
        {
            this._offsetValue = this.transform.localRotation;
            this._targetForward = Quaternion.Euler(this.GetAxisVector() * this.snappingRotationAngle) * this.GetAxisForward();
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
                this._isActive.Value = false;
                return;
            }

            if (!this._isActive.Value)
            {
                this._offsetValue = this.transform.localRotation;
                this._startingNormalizedValue = obj.normalizedFloat;
                this._isActive.Value = true;
            }

            float delta = obj.normalizedFloat - this._startingNormalizedValue;
            Quaternion newLocalRotation = this._offsetValue * Quaternion.Euler(this.GetAxisVector() * (this.rotationAngle * delta));
            Vector3 newForward = newLocalRotation * this.GetAxisForward();

            this._isCorrectAngle.Value = Vector3.Angle(newForward, this._targetForward) < this.snappingThreshold;
            this.transform.localRotation = this._isCorrectAngle.Value ? Quaternion.Euler(this.GetAxisVector() * this.snappingRotationAngle) : newLocalRotation;
        }

        private Vector3 GetAxisVector()
        {
            return this.rotationAxis switch
            {
                Axis.X => Vector3.right,
                Axis.Y => Vector3.up,
                Axis.Z => Vector3.forward,
                _ => throw new ArgumentOutOfRangeException(nameof(this.rotationAxis), this.rotationAxis, null)
            };
        }

        private Vector3 GetAxisForward()
        {
            return this.rotationAxis switch
            {
                Axis.X => Vector3.up,
                Axis.Y => Vector3.forward,
                Axis.Z => Vector3.right,
                _ => throw new ArgumentOutOfRangeException(nameof(this.rotationAxis), this.rotationAxis, null)
            };
        }

        private enum Axis
        {
            X,
            Y,
            Z
        }
    }
}