// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorShaderGlobal : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> reactive;

        [Space]
        [SerializeField]
        private string globalPropertyName;

        [SerializeField]
        private float startValue;

        [SerializeField]
        private float targetValue;

        [SerializeField]
        private float applyTime;

        private CancellationTokenSource _cancellationTokenSource;
        private float _currentValue;
        private int _propertyId;
        private ReactiveSubscription _subscription;

        private void Awake()
        {
            this._propertyId = Shader.PropertyToID(this.globalPropertyName);
        }

        private void OnEnable()
        {
            this._subscription &= this.reactive.Reactive.OnValue(value => this.ApplyValueOverTime(value).Forget());
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
            this._cancellationTokenSource?.Cancel();
            this._cancellationTokenSource?.Dispose();
        }

        private async UniTaskVoid ApplyValueOverTime(bool value)
        {
            this._cancellationTokenSource?.Cancel();
            this._cancellationTokenSource = new CancellationTokenSource();

            float actualStart = this._currentValue;
            float naiveStart = value ? this.startValue : this.targetValue;
            float target = value ? this.targetValue : this.startValue;

            float applyTimeMod = Mathf.Abs(target - this._currentValue) / Mathf.Abs(target - naiveStart);
            float actualApplyTime = this.applyTime * applyTimeMod;

            float t = 0f;

            if (this.applyTime <= 0f)
            {
                this._currentValue = target;
                Shader.SetGlobalFloat(this._propertyId, this._currentValue);
            }
            else
            {
                do
                {
                    this._currentValue = Mathf.Lerp(actualStart, target, t);
                    Shader.SetGlobalFloat(this._propertyId, this._currentValue);

                    t += Time.deltaTime / actualApplyTime;

                    await UniTask.Yield(PlayerLoopTiming.Update, this._cancellationTokenSource.Token);
                } while (t < 1f && !this._cancellationTokenSource.IsCancellationRequested);
            }
        }
    }
}