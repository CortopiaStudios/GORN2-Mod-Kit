// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveStringComparer : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<string> active;
        [SerializeField]
        private bool allowPartialMatch;
        [SerializeField]
        private bool isCaseSensitive = true;
        [SerializeField]
        private BoundValue<string> conditionString;

        [UsedImplicitly]
        public Reactive<bool> ConditionMet => this.active.Reactive.Combine(this.conditionString.Reactive).Select(this.Selector);

        [UsedImplicitly]
        public Reactive<bool> ConditionMetDistinct => this.ConditionMet.DistinctUntilChanged();

        private bool Selector(string arg1, string arg2)
        {
            if (!this.isCaseSensitive)
            {
                arg1 = arg1.ToLowerInvariant();
                arg2 = arg2.ToLowerInvariant();
            }

            return this.allowPartialMatch ? arg1.Contains(arg2) : arg1.Equals(arg2);
        }
    }
}