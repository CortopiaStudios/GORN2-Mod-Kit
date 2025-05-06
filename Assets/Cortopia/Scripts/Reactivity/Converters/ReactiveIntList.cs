// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Converters
{
    public class ReactiveIntList : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> index;

        [SerializeField]
        private List<int> ints;

        [UsedImplicitly]
        public Reactive<int> SelectedInt => this.index.Reactive.Select(i => i < 0 || i >= this.ints.Count ? this.ints[0] : this.ints[i]);
    }
}