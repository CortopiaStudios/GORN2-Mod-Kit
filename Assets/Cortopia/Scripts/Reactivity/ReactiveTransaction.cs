// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Threading;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveTransaction : IDisposable
    {
        private static readonly ThreadLocal<ReactiveTransaction> Instance = new(() => new ReactiveTransaction());
        private readonly Stack<List<IReactiveHandler>> _newMembers = new();

        private List<IReactiveHandler> _members;
        private int _scope;

        private ReactiveTransaction()
        {
        }

        public void Dispose()
        {
            this._scope--;
            if (this._scope > 0 || this._members == null)
            {
                return;
            }

            var theseMembers = this._members;
            this._members = null;

            foreach (IReactiveHandler transactionMember in theseMembers)
            {
                transactionMember.OnValueChanged();
            }

            theseMembers.Clear();
            this._newMembers.Push(theseMembers);
        }

        private void AddMember(IReactiveHandler reactiveTransactionMember)
        {
            if (this._members == null)
            {
                if (!this._newMembers.TryPop(out this._members))
                {
                    this._members = new List<IReactiveHandler>();
                }
            }

            this._members.Add(reactiveTransactionMember);
        }

        public static void Register(IReactiveHandler reactiveTransactionMember)
        {
            ReactiveTransaction instance = Instance.Value;
            if (instance._scope > 0)
            {
                instance.AddMember(reactiveTransactionMember);
            }
            else
            {
                reactiveTransactionMember.OnValueChanged();
            }
        }

        public static ReactiveTransaction Create()
        {
            ReactiveTransaction instance = Instance.Value;
            instance._scope++;
            return instance;
        }
    }
}