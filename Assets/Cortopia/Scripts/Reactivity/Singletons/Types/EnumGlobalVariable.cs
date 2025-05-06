// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;

namespace Cortopia.Scripts.Reactivity.Singletons.Types
{
    public abstract class EnumGlobalVariable<T> : StateGlobalVariable where T : Enum
    {
        public abstract Reactive<T> ActiveState { get; }

        protected override void OnValidate()
        {
            this.states = new List<string>(Enum.GetNames(typeof(T)));

            base.OnValidate();
        }

        public abstract bool TrySetValue(T value);
    }
}