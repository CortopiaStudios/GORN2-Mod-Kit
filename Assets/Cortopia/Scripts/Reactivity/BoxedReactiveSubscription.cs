// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;

namespace Cortopia.Scripts.Reactivity
{
    public class BoxedReactiveSubscription : IDisposable
    {
        private bool _disposed;
        private ReactiveSubscription _subscription;

        public void Dispose()
        {
            this._disposed = true;
            this._subscription.Dispose();
        }

        public void Set(ReactiveSubscription subscription)
        {
            if (this._disposed)
            {
                subscription.Dispose();
            }
            else
            {
                this._subscription = subscription;
            }
        }
    }
}