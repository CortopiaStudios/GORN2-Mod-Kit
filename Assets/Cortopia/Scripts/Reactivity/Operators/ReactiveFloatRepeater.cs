// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Threading;
using Cysharp.Threading.Tasks;
using Cysharp.Threading.Tasks.Linq;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatRepeater : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> inputValue;
        [SerializeField]
        private UpdateMode updateMode;
        [SerializeField]
        private bool multiplyWithDeltaTime;

        private readonly ReactiveSource<float> _repeatedValue = new(0f);
        private CancellationTokenSource _cancellation;

        [UsedImplicitly]
        public Reactive<float> RepeatedValue => this._repeatedValue.Reactive;

        private void OnEnable()
        {
            this.RepeaterStart().Forget();
        }

        private void OnDisable()
        {
            this._cancellation?.Cancel();
            this._cancellation?.Dispose();
            this._cancellation = null;
        }

        private async UniTaskVoid RepeaterStart()
        {
            this._cancellation?.Cancel();
            this._cancellation?.Dispose();
            this._cancellation = new CancellationTokenSource();
            await foreach (AsyncUnit _ in UniTaskAsyncEnumerable.EveryUpdate(ToPlayerLoopTimer(this.updateMode)).WithCancellation(this._cancellation.Token))
            {
                this._repeatedValue.Value = this.inputValue.Reactive.Value * this.GetDeltaTime();
            }
        }

        private float GetDeltaTime()
        {
            if (!this.multiplyWithDeltaTime)
            {
                return 1f;
            }

            return this.updateMode switch
            {
                UpdateMode.Update => Time.deltaTime,
                UpdateMode.FixedUpdate => Time.fixedDeltaTime,
                _ => throw new ArgumentOutOfRangeException()
            };
        }

        private static PlayerLoopTiming ToPlayerLoopTimer(UpdateMode updateMode)
        {
            return updateMode switch
            {
                UpdateMode.Update => PlayerLoopTiming.Update,
                UpdateMode.FixedUpdate => PlayerLoopTiming.FixedUpdate,
                _ => throw new ArgumentOutOfRangeException()
            };
        }

        private enum UpdateMode
        {
            Update,
            FixedUpdate
        }
    }
}