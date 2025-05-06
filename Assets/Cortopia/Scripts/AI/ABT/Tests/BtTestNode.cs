// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Tests
{
    internal class BtTestNode : IBehaviorTree
    {
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private ResettableCancellation.Token _cancellationToken;

        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private UniTaskCompletionSource<bool> _completion;
        private bool? _result;

        public bool ResetResultWhenFinished { get; set; } = true;

        public bool IsRunning => this._completion != null;
        public bool IsCancellationRequested => this._cancellationToken.IsCancellationRequested;

        public string Name { get; set; }
        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => Array.Empty<(IBehaviorTree, StatusTracer)>();
        public Reactive<bool> IsEnabledBranch => this._isEnabledSelf.Reactive;
        public Reactive<bool> IsEnabledSelf => this._isEnabledSelf.Reactive;

        public async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            if (this._completion != null)
            {
                throw new Exception($"BtTestNode {this.Name} was restarted while previous instance was still running");
            }

            if (this._result.HasValue)
            {
                bool result = this._result.Value;
                if (this.ResetResultWhenFinished)
                {
                    this._result = null;
                }

                return result;
            }

            this._completion = new UniTaskCompletionSource<bool>();

            try
            {
                using ResettableCancellation.Scope scope = this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);
                this._cancellationToken = scope.CancellationToken;
                return await this._completion.Task;
            }
            finally
            {
                this._completion = null;
                this._cancellationToken = default(ResettableCancellation.Token);
                if (this.ResetResultWhenFinished)
                {
                    this._result = null;
                }
            }
        }

        public void SetEnabled(bool enabled)
        {
            this._cancelWhenDisabled.Enabled = enabled;
            this._isEnabledSelf.Value = enabled;
        }

        public void SetResult(bool result)
        {
            this._result = result;
            this._completion?.TrySetResult(result);
        }

        public void AcknowledgeCancellation()
        {
            if (this.IsCancellationRequested)
            {
                this._completion.TrySetCanceled();
            }
        }
    }
}