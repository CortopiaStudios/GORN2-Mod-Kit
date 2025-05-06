// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtAction : BtCondition
    {
        private readonly Func<ResettableCancellation.Token, UniTask> _action;

        public BtAction(string name, [NotNull] Action action) : base(name, _ =>
        {
            action();
            return new UniTask<bool>(true);
        })
        {
        }

        public BtAction(string name, [NotNull] Func<ResettableCancellation.Token, UniTask> action) : base(name, async c =>
        {
            await action(c);
            return true;
        })
        {
        }
    }
}