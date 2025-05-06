// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveCloseToCamera : MonoBehaviour
    {
        public BoundValue<float> thresholdDistance;
        private readonly ReactiveSource<float> _distanceSqrToCamera = new(0);

        [UsedImplicitly]
        public Reactive<bool> IsCloseToCamera => this._distanceSqrToCamera.Reactive.Combine(this.thresholdDistance.Reactive).Select((a, b) => a <= b * b);

        private void FixedUpdate()
        {
            this._distanceSqrToCamera.Value = Camera.main ? (Camera.main.transform.position - this.transform.position).sqrMagnitude : 0;
        }
    }
}