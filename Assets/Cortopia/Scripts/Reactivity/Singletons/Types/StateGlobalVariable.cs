// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Singletons.Types
{
    [CreateAssetMenu(menuName = "Cortopia/Global Variable/State")]
    public class StateGlobalVariable : GlobalVariable<int>
    {
        [SerializeField]
        protected List<string> states = new();

        public IList<string> States => this.states;

        protected virtual void OnValidate()
        {
            if (this.Variable.Value < 0)
            {
                Debug.LogError("Initial state value can't be negative.", this);
            }
            else if (this.Variable.Value >= this.states.Count && this.states.Count > 0)
            {
                Debug.LogError("Initial state value greater than the current state count", this);
            }
        }
    }
}