// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using Cortopia.Scripts.AI.ABT.Nodes;
using UnityEngine;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    public class BehaviorGameObjectTree
    {
        private readonly List<BehaviorTreeBase> _group = new();
        private bool _initialized;

        public BtTree WithSubTrees(BtTree tree, Transform transform)
        {
            if (!this._initialized)
            {
                this.Initialize(transform);
            }

            foreach (BehaviorTreeBase subTree in this._group)
            {
                tree.Add(subTree.CreateGameObjectTree());
            }

            return tree;
        }

        private void Initialize(Transform transform)
        {
            foreach (Transform t in transform)
            {
                var node = t.GetComponent<BehaviorTreeBase>();
                if (node == null)
                {
                    continue;
                }

                this._group.Add(node);
            }

            this._initialized = true;
        }
    }
}