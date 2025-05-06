// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.AI.ABT
{
    public abstract class BehaviorTreeBase : AsyncBtBase
    {
        [SerializeField]
        private string btDebugName;

        private IBehaviorTree _lastCreatedTree;

        public string DebugName => string.IsNullOrWhiteSpace(this.btDebugName) ? this.name : this.btDebugName;

        private void OnEnable()
        {
            this._lastCreatedTree?.SetEnabled(true);
        }

        private void OnDisable()
        {
            this._lastCreatedTree?.SetEnabled(this.enabled && this.gameObject.activeSelf);
        }

        protected abstract IBehaviorTree CreateBehaviorTree();

        public IBehaviorTree CreateGameObjectTree()
        {
            this._lastCreatedTree?.SetEnabled(false);
            this._lastCreatedTree = this.CreateBehaviorTree();
            this._lastCreatedTree.SetEnabled(this.enabled && this.gameObject.activeSelf);
            return this._lastCreatedTree;
        }
    }
}