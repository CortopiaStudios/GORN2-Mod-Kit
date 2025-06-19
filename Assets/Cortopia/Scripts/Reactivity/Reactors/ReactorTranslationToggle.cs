// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorTranslationToggle : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> toggleValue;
        [SerializeField]
        private Vector3 truePosition;
        [SerializeField]
        private Vector3 falsePosition;
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;

        [UsedImplicitly]
        public Reactive<bool> IsMoving => new();

        private void Update()
        {
        }

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}