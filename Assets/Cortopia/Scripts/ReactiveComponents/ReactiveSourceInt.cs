// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveSourceInt : MonoBehaviour
    {
        [SerializeField]
        private ReactiveSource<int> value = new(0);

        public ReactiveSource<int> Value => this.value;

        public void Set(int i)
        {
            throw new NotImplementedException();
        }

        public void Increment()
        {
            throw new NotImplementedException();
        }
    }
}