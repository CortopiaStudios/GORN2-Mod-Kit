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
    public class BtBoolCondition : IBehaviorTree
    {
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        private readonly Reactive<bool> _reactiveBool;

        public BtBoolCondition(string name, IBindableReactive<bool> reactiveBool)
        {
            this.Name = name;
            this._reactiveBool = reactiveBool.Reactive;
        }

        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => Array.Empty<(IBehaviorTree, StatusTracer)>();

        public string Name { get; }

        public UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            return new UniTask<bool>(this._reactiveBool.Value);
        }

        public Reactive<bool> IsEnabledBranch => this.IsEnabledSelf;
        public Reactive<bool> IsEnabledSelf => this._isEnabledSelf.Reactive;

        public void SetEnabled(bool enabled)
        {
            this._isEnabledSelf.Value = enabled;
        }
    }
}