// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

namespace Cortopia.Scripts.Reactivity.Utils
{
    public struct Unit
    {
        public static Unit Default { get; } = new();

        public override string ToString()
        {
            return "()";
        }
    }
}