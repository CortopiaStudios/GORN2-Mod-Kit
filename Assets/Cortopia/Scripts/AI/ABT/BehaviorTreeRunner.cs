// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

#if ABT_DEBUG
using System;
using System.Collections.Generic;
#endif
using Cortopia.Scripts.AI.ABT.GameObjectTree;
using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Cortopia.Scripts.AI.ABT
{
    public class BehaviorTreeRunner : AsyncBtBase
#if ABT_DEBUG
        , IBehaviorTreeTracer
#endif
    {
        [SerializeField]
        private BoundValue<bool> restart;
        private UniTask _currentRun;
        private BehaviorGameObjectTree _gameObjectTree;
        private ResettableCancellation _resettableCancellation;
        private UniTask _task;
        private BtTree _tree;

        private void Awake()
        {
            this._gameObjectTree = new BehaviorGameObjectTree();
            this._resettableCancellation = new ResettableCancellation(true);
        }

        protected void OnEnable()
        {
            this._task = this.StartAsync();
        }

        private void OnDisable()
        {
            this._task = this.StopAsync();
        }

        private async UniTask StopAsync()
        {
            await this._task;
            this._resettableCancellation.Cancel();
            await this._currentRun;
            this._tree = null;
        }

        private async UniTask StartAsync()
        {
            await this._task;
            this._resettableCancellation.Reset();
            string btName =
#if ABT_DEBUG
                this.gameObject.name;
#else
                string.Empty;
#endif
            this._tree = this._gameObjectTree.WithSubTrees(new BtDecorator(btName), this.transform);
            this._currentRun = this.RunAsync(this._resettableCancellation.CancellationToken).SuppressCancellationThrow();
        }

        private async UniTask RunAsync(ResettableCancellation.Token cancellationToken)
        {
            var restartOrCancel = this.restart.Reactive.DistinctUntilChanged().Combine(cancellationToken.ReactiveCancellationRequested);
            while (!cancellationToken.IsCancellationRequested)
            {
#if ABT_DEBUG
                this.StatusTracer.Reset();
                await this.StatusTracer.Trace(this._tree.Run, cancellationToken).SuppressCancellationThrow();
#else
                await this._tree.Run(cancellationToken).SuppressCancellationThrow();
#endif
                await UniTask.NextFrame();
                await foreach ((bool doRestart, _) in restartOrCancel)
                {
                    cancellationToken.ThrowIfCancellationRequested();
                    if (doRestart)
                    {
                        break;
                    }
                }
            }
        }

#if ABT_DEBUG
        public string Name => this.gameObject.name;
        public IEnumerable<(IBehaviorTree, StatusTracer)> SubTreeStatuses => this._tree?.SubTreeStatuses ?? Array.Empty<(IBehaviorTree, StatusTracer)>();
        public StatusTracer StatusTracer { get; } = new();
#endif
    }
}