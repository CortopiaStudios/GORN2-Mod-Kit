// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using System.Linq;
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
        public Reactive<bool> All => Reactive.Lazy(() => this.parameters.Select(x => x.Reactive).Combine().Select(x => x.All(y => y)));

        [UsedImplicitly]
        public Reactive<bool> AllDistinct => this.All.DistinctUntilChanged();

        [UsedImplicitly]
        public Reactive<bool> Any => Reactive.Lazy(() => this.parameters.Select(x => x.Reactive).Combine().Select(x => x.Any(y => y)));

        [UsedImplicitly]
        public Reactive<bool> AnyDistinct => this.Any.DistinctUntilChanged();

        [UsedImplicitly]
        public Reactive<bool> AnyEx => this.parameters.Aggregate(Reactive.Constant(false), (acc, x) => acc.Combine(x.Reactive).Select(y => y.Item1 || y.Item2));

        [UsedImplicitly]
        public Reactive<bool> AllEx => this.parameters.Aggregate(Reactive.Constant(true), (acc, x) => acc.Combine(x.Reactive).Select(y => y.Item1 && y.Item2));

        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }
    }
}