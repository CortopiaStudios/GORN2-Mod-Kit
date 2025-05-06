// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Unity.IL2CPP.CompilerServices;

namespace Cortopia.Scripts.Reactivity.Utils
{
    /// <summary>
    ///     Like List{T}
    ///     but without safety checks in enumerator. WARNING: Do not attempt to add items while iterating this, and do not
    ///     try to use enumerator without foreach!
    /// </summary>
    /// <typeparam name="T"></typeparam>
    [Il2CppSetOption(Option.NullChecks, false)]
    [Il2CppSetOption(Option.ArrayBoundsChecks, false)]
    public class FastUnsafeList<T>
    {
        private const int InitialCapacity = 4;
        private T[] _arr;
        private int _count;

        public FastUnsafeList()
        {
            this._count = 0;
        }

        public bool IsEmpty => this._count == 0;

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public Enumerator GetEnumerator()
        {
            return new Enumerator(this._arr, this._count);
        }

        public void Clear()
        {
            this._count = 0;
        }

        public void Remove(T value)
        {
            for (int i = 0; i < this._count; i++)
            {
                if (EqualityComparer<T>.Default.Equals(this._arr[i], value))
                {
                    this._count--;
                    if (i < this._count)
                    {
                        Array.Copy(this._arr, i + 1, this._arr, i, this._count - i);
                    }

                    return;
                }
            }
        }

        public void Add(T value)
        {
            if (this._arr == null)
            {
                this._arr = new T[InitialCapacity];
            }
            else if (this._count == this._arr.Length)
            {
                var newArr = new T[this._arr.Length * 2];
                Array.Copy(this._arr, newArr, this._arr.Length);
                this._arr = newArr;
            }

            this._arr[this._count] = value;
            this._count++;
        }

        [Il2CppSetOption(Option.NullChecks, false)]
        [Il2CppSetOption(Option.ArrayBoundsChecks, false)]
        public struct Enumerator
        {
            private readonly T[] _arr;
            private readonly int _count;
            private int _i;

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            public Enumerator(T[] arr, int count)
            {
                this._arr = arr;
                this._count = count;
                this._i = -1;
            }

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            public bool MoveNext()
            {
                this._i++;
                return this._i < this._count;
            }

            public T Current
            {
                [MethodImpl(MethodImplOptions.AggressiveInlining)]
                get => this._arr[this._i];
            }
        }
    }
}