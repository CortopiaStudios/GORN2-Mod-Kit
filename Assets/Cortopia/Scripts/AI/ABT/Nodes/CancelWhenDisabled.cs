// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class CancelWhenDisabled
    {
        private readonly ResettableCancellation _cancellation;

        private bool _enabled;

        public CancelWhenDisabled(bool enabled)
        {
            this._cancellation = new ResettableCancellation(!enabled);
            this._enabled = enabled;
        }

        public bool Enabled
        {
            get => this._enabled;
            set
            {
                if (value == this._enabled)
                {
                    return;
                }

                this._enabled = value;

                if (!this._enabled)
                {
                    this._cancellation.Cancel();
                }
            }
        }

        [MustUseReturnValue]
        public ResettableCancellation.Scope CreateLinkedScope(ResettableCancellation.Token cancellationToken)
        {
            if (this._enabled)
            {
                this._cancellation.Reset();
            }

            return cancellationToken.CreateLinkedScope(this._cancellation);
        }
    }
}