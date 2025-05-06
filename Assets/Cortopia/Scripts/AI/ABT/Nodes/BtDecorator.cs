// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Linq;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    /// <summary>
    ///     Base class for all decorator type nodes, ie nodes that will use its first enabled child. It is implicitly disabled
    ///     in case it has no enabled children.
    ///     Can be used as is (i.e. its not abstract) just for the functionality to select the first enabled child.
    /// </summary>
    public class BtDecorator : BtTree
    {
        public BtDecorator(string name) : base(name)
        {
        }

        public override UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            return this.RunSubtree(cancellationToken);
        }

#if ABT_DEBUG
        private int _lastRunBranch = -1;

        protected async UniTask<bool> RunSubtree(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this.CreateLinkedScopeWithCancelWhenDisabled(cancellationToken);

            if (this._lastRunBranch > 0)
            {
                this.StatusTracers[this._lastRunBranch].Reset();
            }

            while (true)
            {
                if (!this.IsEnabledSelf.Value)
                {
                    throw ResettableCancellation.CancelException;
                }

                this._lastRunBranch = this.SubTrees.FindIndex(x => x.IsEnabledBranch.Value);
                if (this._lastRunBranch < 0)
                {
                    throw ResettableCancellation.CancelException;
                }

                try
                {
                    return await this.StatusTracers[this._lastRunBranch].Trace(this.SubTrees[this._lastRunBranch].Run, linkedScope.CancellationToken);
                }
                catch (OperationCanceledException) when (!this.SubTrees[this._lastRunBranch].IsEnabledBranch.Value)
                {
                    // Branch got disabled, try another if anyone else is enabled. Will repeat the while(true) above.
                    this.StatusTracers[this._lastRunBranch].Reset();
                    this._lastRunBranch = -1;
                }
            }
        }
#else
        protected async UniTask<bool> RunSubtree(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this.CreateLinkedScopeWithCancelWhenDisabled(cancellationToken);
            while (true)
            {
                if (!this.IsEnabledSelf.Value)
                {
                    throw ResettableCancellation.CancelException;
                }

                IBehaviorTree firstEnabled = null;
                foreach (IBehaviorTree x in this.SubTrees)
                {
                    if (x.IsEnabledBranch.Value)
                    {
                        firstEnabled = x;
                    }
                }

                if (firstEnabled == null)
                {
                    throw ResettableCancellation.CancelException;
                }

                try
                {
                    return await firstEnabled.Run(linkedScope.CancellationToken);
                }
                catch (OperationCanceledException) when (!firstEnabled.IsEnabledBranch.Value)
                {
                    // Branch got disabled, try another if anyone else is enabled. Will repeat the while(true) above.
                }
            }
        }
#endif

        public override Reactive<bool> IsEnabledBranch =>
            this.IsEnabledSelf.Select(x => x ? this.SubTrees.Select(y => y.IsEnabledBranch).Combine().Select(y => y.Any(z => z)) : Reactive.Constant(false)).Switch();
    }
}