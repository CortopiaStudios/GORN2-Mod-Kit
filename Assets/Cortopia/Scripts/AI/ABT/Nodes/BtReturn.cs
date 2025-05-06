// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtReturn : BtDecorator
    {
        private readonly bool _value;

        public BtReturn(string name, bool value) : base(name)
        {
            this._value = value;
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            await this.RunSubtree(cancellationToken);
            cancellationToken.ThrowIfCancellationRequested();

            return this._value;
        }
    }
}