// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveAndCompare : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> conditionA = new(false);
        [SerializeField]
        private bool invertConditionA;
        [SerializeField]
        private BoundValue<bool> conditionB = new(false);
        [SerializeField]
        private bool invertConditionB;

        public ReactiveAndCompare()
        {
            this.AllConditionsTrue = Reactive.Lazy(() => this.conditionA.Reactive.Value ^ this.invertConditionA && this.conditionB.Reactive.Value ^ this.invertConditionB,
                () => this.conditionA.Reactive.Combine(this.conditionB.Reactive).Select(t => t.Item1 ^ this.invertConditionA && t.Item2 ^ this.invertConditionB));
        }

        [UsedImplicitly]
        public Reactive<bool> AllConditionsTrue { get; }
    }
}