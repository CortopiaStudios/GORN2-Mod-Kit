// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    [DefaultExecutionOrder(-5)]
    public class ReactiveGameObject : MonoBehaviour
    {
        [UsedImplicitly]
        public Reactive<GameObject> GameObject => new();
    }
}