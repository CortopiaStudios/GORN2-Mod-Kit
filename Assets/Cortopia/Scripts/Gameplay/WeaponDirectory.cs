// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class WeaponDirectory : MonoBehaviour
    {
        public ReactiveSource<int> Count => default;
        public Reactive<string> CountTxt => default;

        private void Start()
        {
            throw new NotImplementedException();
        }
    }
}