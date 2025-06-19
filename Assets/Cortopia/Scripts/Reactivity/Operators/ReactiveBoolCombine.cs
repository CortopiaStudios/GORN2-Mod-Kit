// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public sealed class ReactiveBoolCombine : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        private List<BoundValue<bool>> parameters;

        [UsedImplicitly]
        public Reactive<bool> All => new();

        [UsedImplicitly]
        public Reactive<bool> AllDistinct => new();

        [UsedImplicitly]
        public Reactive<bool> Any => new();

        [UsedImplicitly]
        public Reactive<bool> AnyDistinct => new();

        [UsedImplicitly]
        public Reactive<bool> AnyEx => new();

        [UsedImplicitly]
        public Reactive<bool> AllEx => new();

        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }
    }
}