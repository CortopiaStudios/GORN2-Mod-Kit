// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Singletons.Types
{
    [CreateAssetMenu(menuName = "Cortopia/Global Variable/Bool")]
    public sealed class BoolGlobalVariable : GlobalVariable<bool>
    {
        public void Toggle()
        {
            this.variable.Value = !this.variable.Value;
        }
    }
}