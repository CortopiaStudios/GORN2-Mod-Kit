// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Cortopia.Scripts.Reactivity
{
    public struct ArraySnapshot<T> : IReadOnlyList<T>, IEquatable<ArraySnapshot<T>>
    {
        public ArraySnapshot(VersionedList<T> source) : this()
        {
            this._source = source;
            this._version = this._source.CurrentVersion;
        }

        private readonly VersionedList<T> _source;
        private readonly ulong _version;

        public Enumerator GetEnumerator()
        {
            return new Enumerator(this);
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return this.GetEnumerator();
        }

        IEnumerator<T> IEnumerable<T>.GetEnumerator()
        {
            return this.GetEnumerator();
        }

        public int Count => this.IsCorrectVersion() ? this._source.List.Count : throw this.WrongVersion();

        private Exception WrongVersion()
        {
            return new Exception("ArraySnapshot was used after becoming obsolete, please make a copy if you need to retain it");
        }

        public T this[int index] => this.IsCorrectVersion() ? this._source.List[index] : throw this.WrongVersion();

        private bool IsCorrectVersion()
        {
            return this._version == this._source.CurrentVersion;
        }

        public bool Equals(ArraySnapshot<T> other)
        {
            return Equals(this._source, other._source) && this._version == other._version;
        }

        public override bool Equals(object obj)
        {
            return obj is ArraySnapshot<T> other && this.Equals(other);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((this._source != null ? this._source.GetHashCode() : 0) * 397) ^ (int) this._version;
            }
        }

        public static bool operator ==(ArraySnapshot<T> left, ArraySnapshot<T> right)
        {
            return left.Equals(right);
        }

        public static bool operator !=(ArraySnapshot<T> left, ArraySnapshot<T> right)
        {
            return !left.Equals(right);
        }

        public struct Enumerator : IEnumerator<T>
        {
            private ArraySnapshot<T> _snapshot;
            private int _index;

            public Enumerator(ArraySnapshot<T> snapshot)
            {
                this._snapshot = snapshot;
                this._index = -1;
            }

            public bool MoveNext()
            {
                if (!this._snapshot.IsCorrectVersion())
                {
                    throw this._snapshot.WrongVersion();
                }

                this._index++;
                return this._index < this._snapshot._source.List.Count;
            }

            public void Reset()
            {
                this._index = -1;
            }

            public T Current => this._snapshot.IsCorrectVersion() ? this._snapshot._source.List[this._index] : throw this._snapshot.WrongVersion();

            object IEnumerator.Current => this.Current;

            public void Dispose()
            {
            }
        }

        // Own implementation of LINQ-method to avoid boxing 
        public bool All(Func<T, bool> condition)
        {
            foreach (T x in this)
            {
                if (!condition(x))
                {
                    return false;
                }
            }

            return true;
        }

        // Own implementation of LINQ-method to avoid boxing 
        public bool Any(Func<T, bool> condition)
        {
            foreach (T x in this)
            {
                if (condition(x))
                {
                    return true;
                }
            }

            return false;
        }
    }
}