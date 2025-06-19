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
    public class ReactiveIntComparer : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        private BoundValue<int> active;
        [SerializeField]
        private NumericalComparisonOperator conditionOperator;
        [SerializeField]
        private BoundValue<int> conditionInt;

        [UsedImplicitly]
        public Reactive<bool> ConditionMet => new();

        [UsedImplicitly]
        public Reactive<bool> ConditionMetDistinct => new();

        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }
    }
}