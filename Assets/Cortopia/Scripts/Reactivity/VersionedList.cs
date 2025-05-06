// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;

namespace Cortopia.Scripts.Reactivity
{
    public class VersionedList<T>
    {
        public VersionedList()
        {
            this.List = new List<T>();
        }

        public VersionedList(int capacity)
        {
            this.List = new List<T>(capacity);
        }

        public List<T> List { get; }
        public ulong CurrentVersion { get; private set; }

        public void InvalidateSnapshots()
        {
            this.CurrentVersion++;
        }
    }
}