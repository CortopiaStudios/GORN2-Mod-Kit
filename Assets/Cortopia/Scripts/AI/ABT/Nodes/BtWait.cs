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
    public class BtWait : IBehaviorTree
    {
        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private readonly Func<float> _getSeconds;
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private readonly bool _unscaledTime;

        public BtWait(string name, bool unscaledTime, Func<float> getSeconds)
        {
            this.Name = name;
            this._getSeconds = getSeconds;
            this._unscaledTime = unscaledTime;
        }

        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => Array.Empty<(IBehaviorTree, StatusTracer)>();

        public string Name { get; }

        public async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);
            await UniTask.Delay(TimeSpan.FromSeconds(this._getSeconds()), this._unscaledTime, cancellationToken: linkedScope.CancellationToken.AsCancellationToken);
            return true;
        }

        public Reactive<bool> IsEnabledBranch => this.IsEnabledSelf;
        public Reactive<bool> IsEnabledSelf => this._isEnabledSelf.Reactive;

        public void SetEnabled(bool enabled)
        {
            this._cancelWhenDisabled.Enabled = enabled;
            this._isEnabledSelf.Value = enabled;
        }
    }
}