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
    [Serializable]
    public struct AnimationOverride
    {
        public AnimationClip animationClip;
        public string animationName;
        public string animationState;
        public float transitionLength;
        public float fixedTimeOffset;
    }

    public class AnimatorLayerController : AnimatorControllerBase, INamedBindableReactiveOwner
    {
        [SerializeField]
        private BoundValue<AnimationOverride> animationOverride;
        [SerializeField]
        private int layerNumber;

        public Reactive<int> CurrentLayerState => default;
        public Reactive<int> CurrentLayerStateTag => default;
        public Reactive<IntegerCounter> TriggerCounter => default;

        private void Update()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public string GetName(string propertyName)
        {
            return propertyName is nameof(this.CurrentLayerState) or nameof(this.TriggerCounter) ? $"Animation Layer {this.layerNumber}" : null;
        }
    }
}