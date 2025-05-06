// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtScope : BtDecorator
    {
        private readonly ReactiveSource<bool> _inScope;

        public BtScope(string name, ReactiveSource<bool> inScope = null) : base(name)
        {
            this._inScope = inScope ?? new ReactiveSource<bool>(false);
        }

        public Reactive<bool> InScope => this._inScope.Reactive;

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            this._inScope.Value = true;

            bool res;
            try
            {
                res = await this.RunSubtree(cancellationToken);
            }
            finally
            {
                this._inScope.Value = false;
            }

            cancellationToken.ThrowIfCancellationRequested();

            return res;
        }
    }
}