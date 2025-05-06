// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Reactivity.Singletons;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    [CreateAssetMenu(menuName = "Cortopia/Global Variable/IntegerCounter")]
    public sealed class IntegerCounterGlobalVariable : GlobalVariable<IntegerCounter>
    {
        [ContextMenu("IncreaseCounter")]
        public void IncreaseCounter()
        {
            throw new NotImplementedException();
        }
    }
}