// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtAwaitBoolCondition : IBehaviorTree
    {
        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private readonly Action _onCancelled;
        private readonly Action<Result> _onResult;
        private readonly Reactive<Result> _reactiveBool;
        private AutoResetUniTaskCompletionSource<bool> _completionSource;

        public BtAwaitBoolCondition(string name, Reactive<Result> reactiveBool)
        {
            this.Name = name;
            this._reactiveBool = reactiveBool;
            this._onResult = x =>
            {
                if (x == Result.Running)
                {
                    return;
                }

                this._completionSource?.TrySetResult(x == Result.Success);
            };
            this._onCancelled = () => this._completionSource?.TrySetCanceled();
        }

        public string Name { get; }

        public async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);
            this._completionSource = AutoResetUniTaskCompletionSource<bool>.Create();

            Result reactiveBoolValue = this._reactiveBool.Value;
            if (reactiveBoolValue != Result.Running)
            {
                return reactiveBoolValue == Result.Success;
            }

            ReactiveSubscription subscription = this._reactiveBool.OnValue(this._onResult);
            linkedScope.CancellationToken.Cancelled += this._onCancelled;

            try
            {
                return await this._completionSource.Task;
            }
            finally
            {
                linkedScope.CancellationToken.Cancelled -= this._onCancelled;
                subscription.Dispose();
                this._completionSource = null;
            }
        }

        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => Array.Empty<(IBehaviorTree, StatusTracer)>();

        public Reactive<bool> IsEnabledBranch => this.IsEnabledSelf;
        public Reactive<bool> IsEnabledSelf => this._isEnabledSelf.Reactive;

        public void SetEnabled(bool enabled)
        {
            this._cancelWhenDisabled.Enabled = enabled;
            this._isEnabledSelf.Value = enabled;
        }
    }
}