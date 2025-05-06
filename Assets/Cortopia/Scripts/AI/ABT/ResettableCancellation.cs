// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Threading;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;

namespace Cortopia.Scripts.AI.ABT
{
    public class ResettableCancellation
    {
        private readonly List<ResettableCancellation> _linkedCancellations = new();
        private CancellationTokenSource _cancellationTokenSource;

        public ResettableCancellation(bool canceled = false)
        {
            this.IsCancellationRequested = canceled;
        }

        public bool IsCancellationRequested { get; private set; }

        public Token CancellationToken => new(this);

        public static Exception CancelException { get; } = new OperationCanceledException();

        public event Action Cancelled;

        public void Cancel()
        {
            if (this.IsCancellationRequested)
            {
                return;
            }

            this.IsCancellationRequested = true;
            this._cancellationTokenSource?.Cancel();
            this._cancellationTokenSource = null;
            foreach (ResettableCancellation linkedCancellation in this._linkedCancellations)
            {
                linkedCancellation.Cancel();
            }

            this._linkedCancellations.Clear();
            this.Cancelled?.Invoke();
            this.Cancelled = null;
        }

        public void ThrowIfCancellationRequested()
        {
            if (this.IsCancellationRequested)
            {
                throw CancelException;
            }
        }

        public void Reset()
        {
            this.IsCancellationRequested = false;
        }

        public CancellationToken GetOrCreateCancellationToken()
        {
            if (this.IsCancellationRequested)
            {
                return new CancellationToken(true);
            }

            this._cancellationTokenSource ??= new CancellationTokenSource();
            return this._cancellationTokenSource.Token;
        }

        public readonly struct Token
        {
            private readonly ResettableCancellation _cancellation;

            public Token(ResettableCancellation cancellation)
            {
                this._cancellation = cancellation;
            }

            public event Action Cancelled
            {
                add => this._cancellation.Cancelled += value;
                remove => this._cancellation.Cancelled -= value;
            }

            public bool IsCancellationRequested => this._cancellation?.IsCancellationRequested == true;

            public void ThrowIfCancellationRequested()
            {
                this._cancellation?.ThrowIfCancellationRequested();
            }

            public CancellationToken AsCancellationToken => this._cancellation?.GetOrCreateCancellationToken() ?? System.Threading.CancellationToken.None;

            public Reactive<bool> ReactiveCancellationRequested
            {
                get
                {
                    ResettableCancellation cancellation = this._cancellation;
                    return cancellation.IsCancellationRequested
                        ? Reactive.Constant(true)
                        : Reactive.FromEvent(x => cancellation.Cancelled += x, x => cancellation.Cancelled -= x).Select(_ => cancellation.IsCancellationRequested);
                }
            }

            [MustUseReturnValue]
            public Scope CreateLinkedScope(ResettableCancellation linkedCancellation)
            {
                if (this._cancellation == null)
                {
                    return new Scope(null, linkedCancellation);
                }

                this._cancellation.ThrowIfCancellationRequested();
                this._cancellation._linkedCancellations.Add(linkedCancellation);
                return new Scope(this._cancellation, linkedCancellation);
            }
        }

        public readonly struct Scope : IDisposable
        {
            private readonly ResettableCancellation _outer;
            private readonly ResettableCancellation _inner;

            public Scope(ResettableCancellation outer, ResettableCancellation inner)
            {
                this._outer = outer;
                this._inner = inner;
            }

            public void Dispose()
            {
                if (this._outer == null)
                {
                    return;
                }

                if (!this._outer.IsCancellationRequested)
                {
                    // Unregister from outer scope 
                    this._outer._linkedCancellations.Remove(this._inner);
                }
                else
                {
                    // Outer scope caused this inner scope to be cancelled, and it is already unregistered by it.
                    // But now also reset this inner cancellation when the scope is exited so it works next time.
                    // If the inner scope would be canceled by itself, it will not be automatically reset.
                    this._inner.Reset();
                }
            }

            public Token CancellationToken => this._inner.CancellationToken;
        }
    }
}