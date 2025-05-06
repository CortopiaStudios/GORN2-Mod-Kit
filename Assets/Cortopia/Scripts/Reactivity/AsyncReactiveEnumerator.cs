// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Threading;
using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.Reactivity
{
    public class AsyncReactiveEnumerator<T> : IUniTaskAsyncEnumerator<T>
    {
        private readonly CancellationToken _cancellationToken;
        private readonly Reactive<T> _source;
        private UniTaskCompletionSource<bool> _gate;
        private ReactiveSubscription _subscription;

        public AsyncReactiveEnumerator(Reactive<T> source, CancellationToken cancellationToken)
        {
            this._source = source;
            this._cancellationToken = cancellationToken;
            this._gate = new UniTaskCompletionSource<bool>();
            if (cancellationToken.IsCancellationRequested)
            {
                this._gate.TrySetCanceled(cancellationToken);
            }
            else
            {
                this._subscription = source.OnValue(this.Handler);
                if (cancellationToken.CanBeCanceled)
                {
                    cancellationToken.Register(this.Cancel);
                }
            }
        }

        public UniTask DisposeAsync()
        {
            this.Cancel();
            return new UniTask();
        }

        public async UniTask<bool> MoveNextAsync()
        {
            await this._gate.Task;
            this._cancellationToken.ThrowIfCancellationRequested();
            this._gate = new UniTaskCompletionSource<bool>();
            return true;
        }

        public T Current => this._source.Value;

        private void Cancel()
        {
            this._subscription.Dispose();
            this._gate.TrySetCanceled(this._cancellationToken);
        }

        private void Handler(T value)
        {
            this._gate.TrySetResult(true);
        }
    }
}