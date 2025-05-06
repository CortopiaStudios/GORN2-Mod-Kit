// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.Navigation;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveSourceNavMeshAgentType : MonoBehaviour
    {
        [SerializeField]
        private ReactiveSource<NavMeshAgentType> value = new(default(NavMeshAgentType));

        public ReactiveSource<NavMeshAgentType> Value => this.value;
    }
}