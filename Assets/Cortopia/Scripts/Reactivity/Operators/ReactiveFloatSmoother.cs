// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Threading;
using Cysharp.Threading.Tasks;
using Cysharp.Threading.Tasks.Linq;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatSmoother : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> target;
        [SerializeField]
        private float acceleration = 1;

        private readonly ReactiveSource<float> _smoothedValue = new(0f);

        private CancellationTokenSource _smoothCancellation;
        private ReactiveSubscription _subscription;

        [UsedImplicitly]
        public Reactive<float> SmoothedValue => this._smoothedValue.Reactive;

        private void OnEnable()
        {
            this._smoothedValue.Value = this.target.Reactive.Value;
            this._subscription &= this.target.Reactive.OnValue(targetValue => this.UpdateValue(targetValue).Forget());
        }

        private void OnDisable()
        {
            this._smoothCancellation?.Cancel();
            this._smoothCancellation?.Dispose();
            this._smoothCancellation = null;
            this._subscription.Dispose();
        }

        private async UniTaskVoid UpdateValue(float targetValue)
        {
            const float minDiff = 0.005f;

            this._smoothCancellation?.Cancel();
            this._smoothCancellation?.Dispose();
            this._smoothCancellation = new CancellationTokenSource();

            await foreach (AsyncUnit _ in UniTaskAsyncEnumerable.EveryUpdate().WithCancellation(this._smoothCancellation.Token))
            {
                float currentValue = this._smoothedValue.Value;
                float difference = targetValue - currentValue;
                bool positive = difference > minDiff;
                bool negative = difference < -minDiff;
                float newValue = positive ? Mathf.Min(currentValue + this.acceleration * Time.deltaTime, targetValue) :
                    negative ? Mathf.Max(currentValue - this.acceleration * Time.deltaTime, targetValue) : targetValue;
                this._smoothedValue.Value = newValue;

                if (Mathf.Abs(difference) < minDiff)
                {
                    this._smoothCancellation?.Cancel();
                    break;
                }
            }
        }
    }
}