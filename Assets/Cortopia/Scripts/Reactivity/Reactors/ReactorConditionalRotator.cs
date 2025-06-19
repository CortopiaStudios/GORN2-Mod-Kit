// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorConditionalRotator : MonoBehaviour
    {
        [Header("Sources")]
        [SerializeField]
        private BoundValue<float> normalizedValue;
        [SerializeField]
        private BoundValue<bool> isConnectionActive;
        [Header("Settings")]
        [SerializeField]
        private Axis rotationAxis;
        [SerializeField]
        private float rotationAngle;
        [SerializeField]
        private float snappingRotationAngle;
        [SerializeField]
        private float snappingThreshold;

        [UsedImplicitly]
        public Reactive<bool> IsActive => new();

        [UsedImplicitly]
        public Reactive<bool> IsCorrectAngle => new();

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }

        private enum Axis
        {
            X,
            Y,
            Z
        }
    }
}