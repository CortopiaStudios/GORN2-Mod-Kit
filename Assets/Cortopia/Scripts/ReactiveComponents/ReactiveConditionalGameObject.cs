﻿// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveConditionalGameObject : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> condition;
        [SerializeField]
        private BoundValue<GameObject> valueOnTrue;
        [SerializeField]
        private BoundValue<GameObject> valueOnFalse;

        public Reactive<GameObject> Value => default;
    }
}