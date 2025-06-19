// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorShaderGlobal : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> reactive;

        [Space]
        [SerializeField]
        private string globalPropertyName;

        [SerializeField]
        private float startValue;

        [SerializeField]
        private float targetValue;

        [SerializeField]
        private float applyTime;

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}