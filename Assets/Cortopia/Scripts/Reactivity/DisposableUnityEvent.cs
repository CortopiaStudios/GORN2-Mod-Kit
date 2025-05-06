// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine.Events;

namespace Cortopia.Scripts.Reactivity
{
    public class DisposableUnityEvent : UnityEvent, IDisposable
    {
        private readonly IDisposable _disposable;

        public DisposableUnityEvent(Func<DisposableUnityEvent, IDisposable> disposableFunc)
        {
            this._disposable = disposableFunc(this);
        }

        public void Dispose()
        {
            this._disposable?.Dispose();
        }
    }

    public class DisposableUnityEvent<T> : UnityEvent<T>, IDisposable
    {
        private readonly IDisposable _disposable;

        public DisposableUnityEvent(Func<DisposableUnityEvent<T>, IDisposable> disposableFunc)
        {
            this._disposable = disposableFunc(this);
        }

        public void Dispose()
        {
            this._disposable?.Dispose();
        }
    }
}