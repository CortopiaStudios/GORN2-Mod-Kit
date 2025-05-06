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
    public abstract class BtUpdater : IBehaviorTree
    {
        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private readonly PlayerLoopTiming _timing;

        protected BtUpdater(string name, PlayerLoopTiming timing)
        {
            this.Name = name;
            this._timing = timing;
        }

        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => Array.Empty<(IBehaviorTree, StatusTracer)>();

        public string Name { get; }

        public async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);

            this.OnStart();
            try
            {
                while (true)
                {
                    Result status = this.OnUpdate();
                    if (status != Result.Running)
                    {
                        return status == Result.Success;
                    }

                    await UniTask.NextFrame(this._timing);
                    linkedScope.CancellationToken.ThrowIfCancellationRequested();
                }
            }
            finally
            {
                this.OnEnd();
            }
        }

        public Reactive<bool> IsEnabledBranch => this.IsEnabledSelf;
        public Reactive<bool> IsEnabledSelf => this._isEnabledSelf.Reactive;

        public void SetEnabled(bool enabled)
        {
            this._cancelWhenDisabled.Enabled = enabled;
            this._isEnabledSelf.Value = enabled;
        }

        protected abstract void OnStart();
        protected abstract Result OnUpdate();
        protected abstract void OnEnd();
    }
}