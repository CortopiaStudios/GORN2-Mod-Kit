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
    public abstract class BtGroup : BtComposite
    {
        public enum Mode
        {
            EvaluateSubTreesOnce,
            KeepReevaluatingHigherSubTrees
        }

        private readonly bool _identity;
        private readonly bool _keepReevaluatingHigherSubTrees;
        private readonly List<(Action<bool> onResult, Action onCancel)> _reenableHandlers = new();
        private readonly List<AutoResetUniTaskCompletionSource> _reenableTasks = new();
        private readonly List<(ResettableCancellation own, ResettableCancellation following)> _reevaluateCancellations = new();

        protected BtGroup(string name, bool identity, Mode mode = Mode.EvaluateSubTreesOnce) : base(name)
        {
            this._identity = identity;
            this._keepReevaluatingHigherSubTrees = mode == Mode.KeepReevaluatingHigherSubTrees;
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this.CreateLinkedScopeWithCancelWhenDisabled(cancellationToken);
            this.ResetAllSubTreeStatusTracers();
            return this._keepReevaluatingHigherSubTrees && this.Count > 1
                ? await this.WithReevaluate(linkedScope.CancellationToken)
                : await this.WithoutReevaluate(linkedScope.CancellationToken);
        }

        private async UniTask<bool> WithReevaluate(ResettableCancellation.Token cancellationToken)
        {
            while (this._reevaluateCancellations.Count < this.Count - 1)
            {
                int i = this._reevaluateCancellations.Count;
                this._reevaluateCancellations.Add((new ResettableCancellation(), new ResettableCancellation()));
                this._reenableTasks.Add(null);
                this._reenableHandlers.Add((x =>
                {
                    if (x)
                    {
                        this._reenableTasks[i].TrySetResult();
                    }
                }, () => this._reenableTasks[i].TrySetCanceled()));
            }

            return await this.EvaluateAndReevaluate(0, cancellationToken);
        }

        private async UniTask<bool> EvaluateAndReevaluate(int index, ResettableCancellation.Token cancellationToken)
        {
            bool? res = await this.RunSubtree(index, cancellationToken);

            if (res == !this._identity)
            {
                return !this._identity;
            }

            if (index + 1 >= this.Count)
            {
                return this._identity;
            }

            return await this.ReevaluateAndContinue(index, cancellationToken);
        }

        private async UniTask<bool> ReevaluateAndContinue(int index, ResettableCancellation.Token cancellationToken)
        {
            while (true)
            {
                (ResettableCancellation ownReevaluationCancellation, ResettableCancellation nextCancellation) = this._reevaluateCancellations[index];
                ownReevaluationCancellation.Reset();
                nextCancellation.Reset();
                using (cancellationToken.CreateLinkedScope(ownReevaluationCancellation))
                using (cancellationToken.CreateLinkedScope(nextCancellation))
                {
                    var reevaluate = this.Reevaluate(index, nextCancellation, ownReevaluationCancellation.CancellationToken);

                    bool nextRes;
                    try
                    {
                        nextRes = await this.EvaluateAndReevaluate(index + 1, nextCancellation.CancellationToken);
                    }
                    catch (OperationCanceledException)
                    {
                        // Either this Reevaluate was the one cancelling and then has a result here, or cancellationToken was cancelled and then this will also be cancelled
                        bool? res = await reevaluate;
                        if (!res.HasValue)
                        {
                            continue;
                        }

                        return res.Value;
                    }

                    ownReevaluationCancellation.Cancel();
                    await reevaluate.SuppressCancellationThrow();

                    return nextRes;
                }
            }
        }

        private async UniTask<bool?> Reevaluate(int index, ResettableCancellation linkedTokenSource, ResettableCancellation.Token cancellationToken)
        {
            while (true)
            {
                await UniTask.NextFrame();
                cancellationToken.ThrowIfCancellationRequested();

                if (!this.SubTrees[index].IsEnabledBranch.Value)
                {
                    // First await this becoming enabled
                    this._reenableTasks[index] = AutoResetUniTaskCompletionSource.Create();
                    (var onResult, Action onCancel) = this._reenableHandlers[index];
                    ReactiveSubscription subscription = this.SubTrees[index].IsEnabledBranch.OnValue(onResult);
                    cancellationToken.Cancelled += onCancel;

                    try
                    {
                        await this._reenableTasks[index].Task;
                    }
                    finally
                    {
                        cancellationToken.Cancelled -= onCancel;
                        subscription.Dispose();
                        this._reenableTasks[index] = null;
                    }
                }

                var uniTask = this.RunSubtree(index, cancellationToken);
                bool? res;
                if (uniTask.Status == UniTaskStatus.Pending)
                {
                    this.ResetLowerPrioStatusTracers(index);
                    linkedTokenSource.Cancel();

                    res = await uniTask;
                    if (res == !this._identity)
                    {
                        return !this._identity;
                    }

                    return null; // This want to restart but has already cancelled the following, need to restart in outer method 
                }

                res = await uniTask;
                if (res == !this._identity)
                {
                    this.ResetLowerPrioStatusTracers(index);
                    linkedTokenSource.Cancel();

                    return !this._identity;
                }
            }
        }

        // ReSharper disable once UnusedParameter.Local
        private void ResetLowerPrioStatusTracers(int index)
        {
#if ABT_DEBUG
            for (int i = index + 1; i < this.Count; i++)
            {
                this.GetSubTreeStatusTracer(i).Reset();
            }
#endif
        }

        private async UniTask<bool> WithoutReevaluate(ResettableCancellation.Token cancellationToken)
        {
            for (int i = 0; i < this.Count; i++)
            {
                bool? res = await this.RunSubtree(i, cancellationToken);
                cancellationToken.ThrowIfCancellationRequested();
                if (res == !this._identity)
                {
                    return !this._identity;
                }
            }

            return this._identity;
        }
    }
}