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
    public class ReactiveSourceVector3 : MonoBehaviour
    {
        [SerializeField]
        private ReactiveSource<Vector3> value = new(default(Vector3));

        public ReactiveSource<Vector3> Value => this.value;

        public void Set(Vector3 x)
        {
            throw new NotImplementedException();
        }
    }
}