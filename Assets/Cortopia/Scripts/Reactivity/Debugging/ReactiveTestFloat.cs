// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Debugging
{
    public class ReactiveTestFloat : MonoBehaviour
    {
        [SerializeField]
        private Axis controlAxis;
        [SerializeField]
        private Vector2 range;

        private readonly ReactiveSource<float> _normalizedValue = new(0f);

        private Vector3 _startingLocalPosition;
        private Vector3 _startingPosition;

        [UsedImplicitly]
        public Reactive<float> NormalizedValue => this._normalizedValue.Reactive;

        private void Start()
        {
            Transform myTransform = this.transform;
            this._startingPosition = myTransform.position;
            this._startingLocalPosition = myTransform.localPosition;
        }

        private void Update()
        {
            Transform myTransform = this.transform;
            Vector3 myPosition = myTransform.localPosition;
            Vector3 clampedPosition = this.controlAxis switch
            {
                Axis.X => new Vector3(myPosition.x, this._startingLocalPosition.y, this._startingLocalPosition.z),
                Axis.Y => new Vector3(this._startingLocalPosition.x, myPosition.y, this._startingLocalPosition.z),
                Axis.Z => new Vector3(this._startingLocalPosition.x, this._startingLocalPosition.y, myPosition.z),
                _ => throw new ArgumentOutOfRangeException()
            };

            float startingValue = this.controlAxis switch
            {
                Axis.X => this._startingLocalPosition.x,
                Axis.Y => this._startingLocalPosition.y,
                Axis.Z => this._startingLocalPosition.z,
                _ => throw new ArgumentOutOfRangeException()
            };

            float currentValue = this.controlAxis switch
            {
                Axis.X => clampedPosition.x,
                Axis.Y => clampedPosition.y,
                Axis.Z => clampedPosition.z,
                _ => throw new ArgumentOutOfRangeException()
            };

            myTransform.localPosition = clampedPosition;
            this._normalizedValue.Value = Mathf.InverseLerp(startingValue + this.range.x, startingValue + this.range.y, currentValue);
        }

        private void OnDrawGizmos()
        {
            Transform myTransform = this.transform;
            Vector3 myPosition = myTransform.position;
            Quaternion myRotation = myTransform.rotation;

            Vector3 vectorAxis = this.GetVectorAxis();
            Vector3 minVector = myRotation * (vectorAxis * this.range.x);
            Vector3 maxVector = myRotation * (vectorAxis * this.range.y);

            Vector3 startPosition = Application.isPlaying ? this._startingPosition + minVector : myPosition + minVector;
            Vector3 endPosition = Application.isPlaying ? this._startingPosition + maxVector : myPosition + maxVector;

            Gizmos.DrawLine(startPosition, endPosition);
        }

        private Vector3 GetVectorAxis()
        {
            return this.controlAxis switch
            {
                Axis.X => Vector3.right,
                Axis.Y => Vector3.up,
                Axis.Z => Vector3.forward,
                _ => throw new ArgumentOutOfRangeException(nameof(this.controlAxis), this.controlAxis, null)
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