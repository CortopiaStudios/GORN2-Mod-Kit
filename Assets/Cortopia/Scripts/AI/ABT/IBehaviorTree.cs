// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

#if ABT_DEBUG
using System.Collections.Generic;
#endif
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT
{
#if ABT_DEBUG
    public interface IBehaviorTreeTracer
    {
        string Name { get; }
        IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses { get; }
    }
#endif

    public interface IBehaviorTree
#if ABT_DEBUG
        : IBehaviorTreeTracer
#endif
    {
        Reactive<bool> IsEnabledBranch { get; }
        Reactive<bool> IsEnabledSelf { get; }
        UniTask<bool> Run(ResettableCancellation.Token cancellationToken);
        void SetEnabled(bool enabled);
    }
}