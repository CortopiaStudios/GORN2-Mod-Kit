// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.UI
{
    public class ReactiveFormatString : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<string> format;
        [SerializeField]
        private BoundValue<string>[] parameters;

        public Reactive<string> Result => default;
    }
}