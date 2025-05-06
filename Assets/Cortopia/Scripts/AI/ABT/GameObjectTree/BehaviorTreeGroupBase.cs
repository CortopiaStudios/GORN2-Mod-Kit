// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.ABT.Nodes;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    public abstract class BehaviorTreeGroupBase : BehaviorTreeBase
    {
        private readonly BehaviorGameObjectTree _gameObjectTree = new();

        protected BtTree WithSubTrees(BtTree tree)
        {
            return this._gameObjectTree.WithSubTrees(tree, this.transform);
        }
    }
}