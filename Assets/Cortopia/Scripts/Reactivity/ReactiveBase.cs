// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

namespace Cortopia.Scripts.Reactivity
{
    public abstract class ReactiveBase : ReactiveTrigger
    {
        protected override void AddHandler(IReactiveHandler handler)
        {
            if (!this.HasHandlers)
            {
                this.Subscribe();
            }

            base.AddHandler(handler);
        }

        protected override void RemoveHandler(IReactiveHandler handler)
        {
            base.RemoveHandler(handler);
            if (!this.HasHandlers)
            {
                this.UnSubscribe();
            }
        }

        protected abstract void Subscribe();
        protected abstract void UnSubscribe();
    }
}