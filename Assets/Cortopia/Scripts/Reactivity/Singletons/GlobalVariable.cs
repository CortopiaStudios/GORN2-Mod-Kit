// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Singletons
{
    public abstract class GlobalVariable : ScriptableObject
    {
        public abstract Reactive<object> DynamicValue { get; }
    }

    public class GlobalVariable<T> : GlobalVariable
    {
        [SerializeField]
        protected ReactiveSource<T> variable;

        public ReactiveSource<T> Variable => this.variable;

        public override Reactive<object> DynamicValue => this.variable.Reactive.Select(x => (object) x);

        public void Set(T value)
        {
            this.variable.Value = value;
        }
    }
}