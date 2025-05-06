// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Linq;
using Cortopia.Scripts.Reactivity.Utils;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveTrigger
    {
        private readonly FastUnsafeList<IReactiveHandler> _handlers = new();

        private readonly Action<object> _registeredRemoveHandler;
        private List<IReactiveHandler> _addedHandlers;
        private bool _changing;
        private List<IReactiveHandler> _removedHandlers;

        protected ReactiveTrigger()
        {
            this._registeredRemoveHandler = obj => this.RemoveHandler((IReactiveHandler) obj);
        }

        protected bool HasHandlers => !this._handlers.IsEmpty;

        public ReactiveSubscription OnValueUpdate(IReactiveHandler handler)
        {
            this.AddHandler(handler);
            return new ReactiveSubscription(this._registeredRemoveHandler, handler);
        }

        protected virtual void RemoveHandler(IReactiveHandler handler)
        {
            if (!this._changing)
            {
                this._handlers.Remove(handler);
            }
            else
            {
                this._removedHandlers ??= new List<IReactiveHandler>();
                this._removedHandlers.Add(handler);
            }
        }

        protected virtual void AddHandler(IReactiveHandler handler)
        {
            if (!this._changing)
            {
                this._handlers.Add(handler);
            }
            else
            {
                this._addedHandlers ??= new List<IReactiveHandler>();
                this._addedHandlers.Add(handler);
            }
        }

        public void OnValueChanging()
        {
            if (this._changing)
            {
                // This has already been notified that it is about to change, no need to notify it again
                // This will e.g. happen if same reactive is used in two places in a combine or if SetValue is
                // called multiple times in a transaction
                return;
            }

            this._changing = true;

            List<Exception> exceptions = null;
            foreach (IReactiveHandler reactiveHandler in this._handlers)
            {
                try
                {
                    reactiveHandler.OnValueChanging();
                }
                catch (Exception e)
                {
                    exceptions ??= new List<Exception>();
                    exceptions.Add(e);
                }
            }

            while (this._addedHandlers?.Count > 0 || this._removedHandlers?.Count > 0)
            {
                var addedHandlers = (this._addedHandlers ?? Enumerable.Empty<IReactiveHandler>()).Except(this._removedHandlers ?? Enumerable.Empty<IReactiveHandler>())
                    .ToList();
                var removedHandlers = (this._removedHandlers ?? Enumerable.Empty<IReactiveHandler>()).Except(this._addedHandlers ?? Enumerable.Empty<IReactiveHandler>())
                    .ToList();
                this._addedHandlers?.Clear();
                this._removedHandlers?.Clear();

                // Add new handlers and start their change as well
                foreach (IReactiveHandler reactiveHandler in addedHandlers)
                {
                    this._handlers.Add(reactiveHandler);
                    try
                    {
                        reactiveHandler.OnValueChanging();
                    }
                    catch (Exception e)
                    {
                        exceptions ??= new List<Exception>();
                        exceptions.Add(e);
                    }
                }

                // Remove old handlers and cancel their started change
                foreach (IReactiveHandler reactiveHandler in removedHandlers)
                {
                    this._handlers.Remove(reactiveHandler);
                    try
                    {
                        reactiveHandler.OnValueChangeCancelled();
                    }
                    catch (Exception e)
                    {
                        exceptions ??= new List<Exception>();
                        exceptions.Add(e);
                    }
                }
            }

            if (exceptions != null)
            {
                throw new AggregateException("One or more reactive handlers threw exceptions during OnValueChanging", exceptions);
            }
        }

        public void OnValueChanged()
        {
            if (!this._changing)
            {
                // If it has already got notified that it was finished changing it already have everything up to date
                // This will e.g. happen if same reactive is used in two places in a combine or if SetValue is
                // called multiple times in a transaction
                return;
            }

            List<Exception> exceptions = null;
            foreach (IReactiveHandler reactiveHandler in this._handlers)
            {
                try
                {
                    reactiveHandler.OnValueChanged();
                }
                catch (Exception e)
                {
                    exceptions ??= new List<Exception>();

                    exceptions.Add(e);
                }
            }

            while (this._addedHandlers?.Count > 0 || this._removedHandlers?.Count > 0)
            {
                var addedHandlers = (this._addedHandlers ?? Enumerable.Empty<IReactiveHandler>()).Except(this._removedHandlers ?? Enumerable.Empty<IReactiveHandler>())
                    .ToList();
                var removedHandlers = (this._removedHandlers ?? Enumerable.Empty<IReactiveHandler>()).Except(this._addedHandlers ?? Enumerable.Empty<IReactiveHandler>())
                    .ToList();
                this._addedHandlers?.Clear();
                this._removedHandlers?.Clear();

                // Add handlers, but no change is needed (they were added while changed so they already saw up to date values)
                foreach (IReactiveHandler reactiveHandler in addedHandlers)
                {
                    this._handlers.Add(reactiveHandler);
                }

                // Remove handlers, but no cancel is needed (they already got changed)
                foreach (IReactiveHandler reactiveHandler in removedHandlers)
                {
                    this._handlers.Remove(reactiveHandler);
                }
            }

            this._changing = false;

            if (exceptions != null)
            {
                throw new AggregateException("One or more reactive handlers threw exceptions during OnValueChanged", exceptions);
            }
        }

        public void OnValueChangeCancelled()
        {
            if (!this._changing)
            {
                // If it has already got notified that it was canceled changing it already have everything up to date
                // This will e.g. happen if same reactive is used in two places in a combine or if SetValue is
                // called multiple times in a transaction
                return;
            }

            List<Exception> exceptions = null;
            foreach (IReactiveHandler reactiveHandler in this._handlers)
            {
                try
                {
                    reactiveHandler.OnValueChangeCancelled();
                }
                catch (Exception e)
                {
                    exceptions ??= new List<Exception>();

                    exceptions.Add(e);
                }
            }

            while (this._addedHandlers?.Count > 0 || this._removedHandlers?.Count > 0)
            {
                var addedHandlers = (this._addedHandlers ?? Enumerable.Empty<IReactiveHandler>()).Except(this._removedHandlers ?? Enumerable.Empty<IReactiveHandler>())
                    .ToList();
                var removedHandlers = (this._removedHandlers ?? Enumerable.Empty<IReactiveHandler>()).Except(this._addedHandlers ?? Enumerable.Empty<IReactiveHandler>())
                    .ToList();
                this._addedHandlers?.Clear();
                this._removedHandlers?.Clear();

                // Add handlers, but no cancel is needed (they were added while changed so they already saw up to date values)
                foreach (IReactiveHandler reactiveHandler in addedHandlers)
                {
                    this._handlers.Add(reactiveHandler);
                }

                // Remove handlers, but no cancel is needed (they already got cancel)
                foreach (IReactiveHandler reactiveHandler in removedHandlers)
                {
                    this._handlers.Remove(reactiveHandler);
                }
            }

            this._changing = false;

            if (exceptions != null)
            {
                throw new AggregateException("One or more reactive handlers threw exceptions during OnValueChangeCancelled", exceptions);
            }
        }
    }
}