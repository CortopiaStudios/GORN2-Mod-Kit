// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents.Animator
{
    public class ReactiveSourceAnimationOverride : MonoBehaviour
    {
        [SerializeField]
        private ReactiveSource<AnimationOverride> value = new(default(AnimationOverride));

        public ReactiveSource<AnimationOverride> Value => default;

        public void Set(AnimationOverride g)
        {
            throw new NotImplementedException();
        }
    }
}