// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtInverter : BtDecorator
    {
        public BtInverter(string name) : base(name)
        {
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            return !await this.RunSubtree(cancellationToken);
        }
    }
}