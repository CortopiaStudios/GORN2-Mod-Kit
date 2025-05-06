// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using JetBrains.Annotations;

namespace Cortopia.Scripts.Reactivity
{
    public class WritableNonReactiveBinding<T> : IWritableBindableReactive<T>
    {
        private readonly Action<T> _setMethod;
        private readonly ReactiveSource<T> _source;

        public WritableNonReactiveBinding(T value, [NotNull] Action<T> setMethod)
        {
            this._source = new ReactiveSource<T>(value);
            this._setMethod = setMethod ?? throw new ArgumentNullException(nameof(setMethod));
        }

        public bool IsReadOnly => false;
        public Reactive<T> Reactive => this._source.Reactive;

        public bool TrySetValue(in T value)
        {
            this.SetValue(value);
            return true;
        }

        public void SetValue(in T value)
        {
            this._setMethod(value);
            this._source.Value = value;
        }
    }
}