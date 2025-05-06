// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;

namespace Cortopia.Scripts.Reactivity
{
    public struct ReactiveSubscription : IDisposable
    {
        private Action<object> _unsubscribe;
        private object _state;

        public ReactiveSubscription(Action<object> unsubscribe, object state)
        {
            this._unsubscribe = unsubscribe;
            this._state = state;
        }

        public void Dispose()
        {
            this._unsubscribe?.Invoke(this._state);
            this._unsubscribe = null;
            this._state = null;
        }

        public static ReactiveSubscription operator &(in ReactiveSubscription a, in ReactiveSubscription b)
        {
            if (b._unsubscribe == null)
            {
                return a;
            }

            if (a._unsubscribe == null)
            {
                return b;
            }

            var aUnsubscribe = a._unsubscribe;
            var bUnsubscribe = b._unsubscribe;
            object aState = a._state;
            object bState = b._state;
            return new ReactiveSubscription(_ =>
            {
                aUnsubscribe(aState);
                bUnsubscribe(bState);
            }, null);
        }
    }
}