// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Diagnostics.Contracts;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    [Serializable]
    public struct IntegerCounter : IEquatable<IntegerCounter>
    {
        public uint CounterValue { get; private set; }

        [Pure]
        public IntegerCounter Incremented => new() {CounterValue = this.CounterValue + 1};

        public bool Equals(IntegerCounter other)
        {
            return this.CounterValue == other.CounterValue;
        }

        public override bool Equals(object obj)
        {
            return obj is IntegerCounter other && this.Equals(other);
        }

        public override int GetHashCode()
        {
            return (int) this.CounterValue;
        }
    }

    public class ReactiveCounter : MonoBehaviour, IBindableReactive<IntegerCounter>
    {
        private readonly ReactiveSource<IntegerCounter> _counter = new(default(IntegerCounter));

        public bool IsReadOnly => true;
        public Reactive<IntegerCounter> Reactive => this._counter.Reactive;

        public bool TrySetValue(in IntegerCounter value)
        {
            // We can't set value to Counter. 
            return false;
        }

        public void IncreaseCounter()
        {
            if (!this.gameObject.activeInHierarchy)
            {
                return;
            }

            this._counter.Value = this._counter.Value.Incremented;
        }
    }
}