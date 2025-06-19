// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorConditionalTranslator : MonoBehaviour
    {
        [Header("Sources")]
        [SerializeField]
        private BoundValue<float> normalizedValue;
        [SerializeField]
        private BoundValue<bool> isConnectionActive;
        [Header("Settings")]
        [SerializeField]
        private Vector3 targetLocalPosition;
        [SerializeField]
        private Vector3 startPosition;
        [SerializeField]
        private Vector3 endPosition;
        [SerializeField]
        private float targetDistanceThreshold;

        [UsedImplicitly]
        public Reactive<bool> IsActive => new();

        [UsedImplicitly]
        public Reactive<bool> IsCorrectPosition => new();

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}