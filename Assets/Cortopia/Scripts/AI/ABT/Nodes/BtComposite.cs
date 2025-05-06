// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public abstract class BtComposite : BtTree
    {
        protected BtComposite(string name) : base(name)
        {
        }

        protected int Count => this.SubTrees.Count;

#if ABT_DEBUG
        protected StatusTracer GetSubTreeStatusTracer(int index)
        {
            return this.StatusTracers[index];
        }

        protected void ResetAllSubTreeStatusTracers()
        {
            for (int i = 0; i < this.Count; i++)
            {
                this.GetSubTreeStatusTracer(i).Reset();
            }
        }

        protected async UniTask<bool?> RunSubtree(int subTreeIndex, ResettableCancellation.Token cancellationToken)
        {
            IBehaviorTree subTree = this.SubTrees[subTreeIndex];
            StatusTracer statusTracer = this.StatusTracers[subTreeIndex];
                
            if (!subTree.IsEnabledBranch.Value)
            {
                return null;
            }

            try
            {
                return await statusTracer.Trace(subTree.Run, cancellationToken);
            }
            catch (OperationCanceledException) when (!subTree.IsEnabledBranch.Value)
            {
                // Branch got disabled
                statusTracer.Reset();
                return null;
            }
        }
#else
        protected async UniTask<bool?> RunSubtree(int subTree, ResettableCancellation.Token cancellationToken)
        {
            if (!this.SubTrees[subTree].IsEnabledBranch.Value)
            {
                return null;
            }

            try
            {
                return await this.SubTrees[subTree].Run(cancellationToken);
            }
            catch (OperationCanceledException) when (!this.SubTrees[subTree].IsEnabledBranch.Value)
            {
                // Branch got disabled
                return null;
            }
        }

        protected void ResetAllSubTreeStatusTracers()
        {
        }
#endif

        public override Reactive<bool> IsEnabledBranch => this.IsEnabledSelf; // The composite works even though some branches are disabled
    }
}