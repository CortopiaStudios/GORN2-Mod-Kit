// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveTransformDistanceCheck : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> transformA;
        [SerializeField]
        private BoundValue<Transform> transformB;
        [SerializeField]
        private float maxDistance;
        private readonly ReactiveSource<float> _currentDistance = new(0.0f);
        private readonly ReactiveSource<bool> _isClose = new(false);

        [UsedImplicitly]
        public Reactive<bool> IsClose => this._isClose.Reactive.DistinctUntilChanged();

        [UsedImplicitly]
        public Reactive<float> CurrentDistance => this._currentDistance.Reactive;

        private void Update()
        {
            if (this.transformA.Reactive.Value == null || this.transformB.Reactive.Value == null)
            {
                return;
            }

            this._currentDistance.Value = (this.transformA.Reactive.Value.position - this.transformB.Reactive.Value.transform.position).magnitude;
            this._isClose.Value = this._currentDistance.Value <= this.maxDistance;
        }
    }
}