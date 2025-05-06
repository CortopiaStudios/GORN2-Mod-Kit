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
    public class ReactiveStringList : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> index;

        [SerializeField]
        private List<string> strings;
        
        [UsedImplicitly]
        public Reactive<string> SelectedString => this.index.Reactive.Select(i => i < 0 || i >= this.strings.Count ? string.Empty : this.strings[i]);
    }
}