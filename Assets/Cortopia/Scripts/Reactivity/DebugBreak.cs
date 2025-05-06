// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using static System.Diagnostics.Debugger;

namespace Cortopia.Scripts.Reactivity
{
    internal static class DebugBreak
    {
        internal static void OnChange()
        {
            /////////////////
            //
            // This will break when you have enabled "Break On Change" in the debugger.
            // Check the callstack to find the cause of the change. 
            //
            Break();
            //
            /////////////////
        }
    }
}