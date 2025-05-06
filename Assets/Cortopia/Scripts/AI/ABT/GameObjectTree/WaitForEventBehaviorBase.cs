// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    public class WaitForEventBehaviorBase<T> : BehaviorTreeBase
    {
        [SerializeField]
        private BoundValue<(IntegerCounter, T)> reactiveEvent;

        private readonly ReactiveSource<T> _lastEventData = new(default(T));

        public Reactive<T> LastEventData => this._lastEventData.Reactive;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return new BtAction(this.DebugName, this.Action);
        }

        private async UniTask Action(ResettableCancellation.Token token)
        {
            this._lastEventData.Value = await this.reactiveEvent.Reactive.ToTask(token.AsCancellationToken);
        }
    }
}