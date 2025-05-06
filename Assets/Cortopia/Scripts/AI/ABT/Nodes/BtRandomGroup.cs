// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public abstract class BtRandomGroup : BtComposite
    {
        private readonly bool _identity;
        private readonly Random _rand;

        protected BtRandomGroup(string name, bool identity, int seed) : base(name)
        {
            this._identity = identity;
            this._rand = new Random(seed);
        }

        protected BtRandomGroup(string name, bool identity) : base(name)
        {
            this._identity = identity;
            this._rand = new Random();
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            using ResettableCancellation.Scope linkedScope = this.CreateLinkedScopeWithCancelWhenDisabled(cancellationToken);

            this.ResetAllSubTreeStatusTracers();

            int[] permutation = new int[this.Count];
            for (int i = 0; i < permutation.Length; i++)
            {
                permutation[i] = i;
            }

            for (int i = this.Count; i > 0;)
            {
                int next = this._rand.Next(i);
                bool? res = await this.RunSubtree(permutation[next], linkedScope.CancellationToken);
                linkedScope.CancellationToken.ThrowIfCancellationRequested();
                if (res == !this._identity)
                {
                    return !this._identity;
                }

                i--;
                permutation[next] = permutation[i];
            }

            return this._identity;
        }
    }
}