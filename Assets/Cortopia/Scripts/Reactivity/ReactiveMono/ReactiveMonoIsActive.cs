// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.ReactiveMono
{
    public class ReactiveMonoIsActive : MonoBehaviour
    {
        public Reactive<bool> IsActive => new();

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}