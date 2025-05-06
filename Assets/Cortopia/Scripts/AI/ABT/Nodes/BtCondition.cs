// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtCondition : IBehaviorTree
    {
        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private readonly Func<ResettableCancellation.Token, UniTask<bool>> _condition;
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private readonly Func<bool> _syncCondition;

        public BtCondition(string name, [NotNull] Func<bool> condition)
        {
            this.Name = name;
            this._syncCondition = condition ?? throw new ArgumentNullException(nameof(condition));
        }

        public BtCondition(string name, [NotNull] Func<ResettableCancellation.Token, UniTask<bool>> condition)
        {
            this.Name = name;
            this._condition = condition ?? throw new ArgumentNullException(nameof(condition));
        }

        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => Array.Empty<(IBehaviorTree, StatusTracer)>();

        public string Name { get; }

        public async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            if (this._syncCondition != null)
            {
                if (!this.IsEnabledSelf.Value)
                {
                    throw ResettableCancellation.CancelException;
                }

                return this._syncCondition();
            }

            using ResettableCancellation.Scope linkedScope = this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);
            bool res = await this._condition(linkedScope.CancellationToken);
            linkedScope.CancellationToken.ThrowIfCancellationRequested();
            return res;
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