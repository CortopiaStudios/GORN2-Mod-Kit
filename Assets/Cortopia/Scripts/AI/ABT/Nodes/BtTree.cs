// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
#if ABT_DEBUG
using System.Linq;
#endif

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public abstract class BtTree : IEnumerable<IBehaviorTree>, IBehaviorTree
    {
        private readonly CancelWhenDisabled _cancelWhenDisabled = new(true);
        private readonly ReactiveSource<bool> _isEnabledSelf = new(true);
        protected readonly List<IBehaviorTree> SubTrees = new();

        protected BtTree(string name)
        {
            this.Name = name;
        }

        public string Name { get; }
        public abstract UniTask<bool> Run(ResettableCancellation.Token cancellationToken);

        public abstract Reactive<bool> IsEnabledBranch { get; }
        public Reactive<bool> IsEnabledSelf => this._isEnabledSelf.Reactive;

        public void SetEnabled(bool enabled)
        {
            this._cancelWhenDisabled.Enabled = enabled;
            this._isEnabledSelf.Value = enabled;
        }

        public IEnumerator<IBehaviorTree> GetEnumerator()
        {
            return this.SubTrees.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return this.GetEnumerator();
        }

        public void Add(IBehaviorTree subTree)
        {
            this.SubTrees.Add(subTree);
#if ABT_DEBUG
            this.StatusTracers.Add(new StatusTracer());
#endif
        }

        protected ResettableCancellation.Scope CreateLinkedScopeWithCancelWhenDisabled(ResettableCancellation.Token cancellationToken)
        {
            return this._cancelWhenDisabled.CreateLinkedScope(cancellationToken);
        }

#if ABT_DEBUG
        protected readonly List<StatusTracer> StatusTracers = new();

        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => this.SubTrees.Zip(this.StatusTracers, (tree, tracer) => (tree, tracer));
#endif
    }
}