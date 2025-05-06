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
    /// <summary>
    /// Run the child behaviour if the reactiveBool is true and return it, otherwise return false. Also abort the child if reactiveBool becomes false while its running.
    /// </summary>
    public class BtWhen : BtDecorator
    {
        private readonly Reactive<bool> _reactiveBool;
        private readonly ResettableCancellation _cancellation = new();

        public BtWhen(string name, IBindableReactive<bool> reactiveBool) : base(name)
        {
            this._reactiveBool = reactiveBool.Reactive;
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            if (!this._reactiveBool.Value)
            {
                return false;
            }

            this._cancellation.Reset();

            using ReactiveSubscription subscription = this._reactiveBool.OnValue(x =>
            {
                if (!x)
                {
                    this._cancellation.Cancel();
                }
            });

            using ResettableCancellation.Scope scope = cancellationToken.CreateLinkedScope(this._cancellation);

            bool res;
            try
            {
                res = await this.RunSubtree(scope.CancellationToken);
            }
            catch (OperationCanceledException) when (this._cancellation.IsCancellationRequested && !cancellationToken.IsCancellationRequested)
            {
                res = false;
            }

            return res;
        }
    }
}