// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity.Utils;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatComparer : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        private BoundValue<float> active;
        [SerializeField]
        private NumericalComparisonOperator conditionOperator;
        [SerializeField]
        private BoundValue<float> conditionFloat;

        [UsedImplicitly]
        public Reactive<bool> ConditionMet => this.active.Reactive.Combine(this.conditionFloat.Reactive).Select(this.Selector);

        [UsedImplicitly]
        public Reactive<bool> ConditionMetDistinct => this.ConditionMet.DistinctUntilChanged();

        private bool Selector(float arg1, float arg2)
        {
            return arg1.CompareTo(arg2, this.conditionOperator);
        }
        
        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }
    }
}