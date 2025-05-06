// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveBoolToFloatConverter : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        private BoundValue<bool> condition;
        [Space]
        [SerializeField]
        private BoundValue<float> falseValue;
        [SerializeField]
        private BoundValue<float> trueValue;

        [UsedImplicitly]
        public Reactive<float> Result => this.condition.Reactive.DistinctUntilChanged().Select(x => x ? this.trueValue.Reactive : this.falseValue.Reactive).Switch();
        
        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }
    }
}