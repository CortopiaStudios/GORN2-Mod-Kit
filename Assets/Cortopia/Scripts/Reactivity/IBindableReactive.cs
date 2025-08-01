﻿// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

namespace Cortopia.Scripts.Reactivity
{
    public interface IBindableReactive
    {
        public bool IsReadOnly { get; }
    }

    public interface IBindableReactive<T> : IBindableReactive
    {
        Reactive<T> Reactive { get; }
        bool TrySetValue(in T value);
    }
}