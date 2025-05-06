// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Linq;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtParallel : BtComposite
    {
        public enum Mode
        {
            /// <summary>
            ///     Stop others as soon as one returns false, and then this return false itself. If all finishes with true, this
            ///     returns true. Like AND.
            /// </summary>
            AbortOnFail,
            /// <summary>
            ///     Stop others as soon as one returns true, and then this return true itself. If all finishes with false, this returns
            ///     false. Like OR.
            /// </summary>
            AbortOnSuccess,
            /// <summary>
            ///     Return the first finished result, whatever it is, and stop the others.
            /// </summary>
            AbortOnComplete
        }

        private readonly ResettableCancellation _abort = new();
        private readonly Mode _mode;
        private readonly List<(Action<bool> onResult, Action onCancel)> _reenableHandlers = new();
        private readonly List<AutoResetUniTaskCompletionSource> _reenableTasks = new();
        private readonly List<UniTask<bool?>> _tasks = new();

        public BtParallel(string name, Mode mode = Mode.AbortOnFail) : base(name)
        {
            this._mode = mode;
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            while (this._reenableTasks.Count < this.Count)
            {
                int i = this._reenableTasks.Count;
                this._reenableTasks.Add(null);
                this._reenableHandlers.Add((x =>
                {
                    if (x)
                    {
                        this._reenableTasks[i].TrySetResult();
                    }
                }, () => this._reenableTasks[i].TrySetCanceled()));
            }

            using ResettableCancellation.Scope linkedScope = this.CreateLinkedScopeWithCancelWhenDisabled(cancellationToken);
            this._abort.Reset();
            using (linkedScope.CancellationToken.CreateLinkedScope(this._abort))
            {
                this.ResetAllSubTreeStatusTracers();
                this._tasks.Clear();
                for (int i = 0; i < this.Count; i++)
                {
                    this._tasks.Add(this.RunWhenEnabledAndCancelOthers(i, this._abort));
                }

                bool?[] all = await UniTask.WhenAll(this._tasks);
                linkedScope.CancellationToken.ThrowIfCancellationRequested();
                return this._mode switch
                {
                    Mode.AbortOnFail => all.All(x => x != false),
                    Mode.AbortOnSuccess => all.Any(x => x == true),
                    Mode.AbortOnComplete => all.FirstOrDefault(x => x.HasValue) ?? false,
                    _ => throw new ArgumentOutOfRangeException()
                };
            }
        }

        private async UniTask<bool?> RunWhenEnabledAndCancelOthers(int i, ResettableCancellation abortCancellation)
        {
            while (true)
            {
                bool? res;
                try
                {
                    res = await this.RunSubtree(i, abortCancellation.CancellationToken);
                }
                catch (OperationCanceledException)
                {
                    return null;
                }

                if (abortCancellation.IsCancellationRequested)
                {
                    return null;
                }

                if (!res.HasValue)
                {
                    // Got/was disabled, await it becoming enabled and then restart (unless others are finishing/aborting this BtParallel)
                    this._reenableTasks[i] = AutoResetUniTaskCompletionSource.Create();
                    (var onResult, Action onCancel) = this._reenableHandlers[i];
                    ReactiveSubscription subscription = this.SubTrees[i].IsEnabledBranch.OnValue(onResult);
                    abortCancellation.Cancelled += onCancel;

                    try
                    {
                        await this._reenableTasks[i].Task;
                    }
                    catch (OperationCanceledException)
                    {
                        return null;
                    }
                    finally
                    {
                        abortCancellation.Cancelled -= onCancel;
                        subscription.Dispose();
                        this._reenableTasks[i] = null;
                    }

                    continue;
                }

                bool abort = this._mode switch
                {
                    Mode.AbortOnFail => !res.Value,
                    Mode.AbortOnSuccess => res.Value,
                    Mode.AbortOnComplete => true,
                    _ => throw new ArgumentOutOfRangeException()
                };

                if (abort)
                {
                    abortCancellation.Cancel();
                }

                return res;
            }
        }
    }
}