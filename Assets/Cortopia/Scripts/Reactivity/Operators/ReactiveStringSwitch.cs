// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Linq;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public sealed class ReactiveStringSwitch : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;

        [Tooltip("Select first string in list that has its condition true")]
        [SerializeField]
        private List<Case> cases;

        [Tooltip("String to use if neither case's condition is true")]
        [SerializeField]
        public string defaultValue;

        [UsedImplicitly]
        public Reactive<string> SelectedString =>
            Reactive.Lazy(() => this.cases.Select(x => x.condition.Reactive.Select(b => b ^ x.invertCondition ? x.value : null)).Combine())
                .Select(x => x.FirstOrDefault(y => y != null) ?? this.defaultValue);

        public string GetName(string propertyName)
        {
            return propertyName == nameof(this.SelectedString) ? this.reactiveName?.Trim() : "";
        }

        [Serializable]
        public struct Case
        {
            public string value;
            public BoundValue<bool> condition;
            public bool invertCondition;
        }
    }
}