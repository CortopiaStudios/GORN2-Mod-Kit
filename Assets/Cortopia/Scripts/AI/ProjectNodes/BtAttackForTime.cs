// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.AI.ABT;
using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ProjectNodes
{
    public class BtAttackForTime : IBehaviorTree
    {
        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private readonly WritableBoundValue<bool> _startAttack = new();
        private readonly float _time;
        private float _currentTime;

        public BtAttackForTime(string name, WritableBoundValue<bool> startAttack, float time)
        {
            this.Name = name;
            this._time = time;
            Reactive.Bind(this._startAttack, startAttack);
        }

        public string Name { get; }

        public async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);

            this._startAttack.SetValue(true);
            try
            {
                await UniTask.Delay(TimeSpan.FromSeconds(this._time), cancellationToken: linkedScope.CancellationToken.AsCancellationToken);
            }
            finally
            {
                this._startAttack.SetValue(false);
            }

            return true;
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