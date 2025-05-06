// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class RangedWeaponAimingHandler : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;

        [Space]
        [SerializeField]
        private BoundValue<Transform> currentTarget;

        [SerializeField]
        private BoundValue<float> characterScale;

        [Space]
        [Tooltip(
            "The Transform from where to base the aiming direction. A line is drawn from this point to the current target and the Guide Transform is placed along it.")]
        [SerializeField]
        private Transform aimOrigin;

        [Header("Interpolation Points")]
        [Tooltip(
            "The estimated min and max scale of the character's body. This does not have to correspond to the actual truth, it's only used to interpolate the settings on this component. If the character's scale goes beyond this value, nothing will break.")]
        [SerializeField]
        private Range<float> estimatedBodyScale;

        [Header("Scaled Settings")]
        [Space]
        [Tooltip("Adjusts the rotation of the upper body. This is necessary for the primary hand to to properly align with the secondary while aiming.")]
        [SerializeField]
        private Range<Vector3> bodyIKRotationOffset;

        [Tooltip("Adjusts the distance to the hand guide Transform. This can be used to move the hand aiming the weapon closer or further from the body")]
        [SerializeField]
        private Range<float> handGuideDistance;

        [Tooltip("Adjusts the height of the hand guide Transform. This can be used to raise and lower the hand aiming the weapon.")]
        [SerializeField]
        private Range<float> handGuideHeightCorrection;

        [Header("Output")]
        [Tooltip(
            "A Transform who's position is intended to be locked onto using an IKConstraint. This is intended to guide the left hand (ranged weapons are always held in the left hand) to a proper aiming position.")]
        [SerializeField]
        private Transform leftHandGuide;

        public Reactive<Vector3> BodyIKRotationOffset => new();

        private void FixedUpdate()
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

        [Serializable]
        private class Range<T>
        {
            [SerializeField]
            private BoundValue<T> min;

            [SerializeField]
            private BoundValue<T> max;

            public Reactive<T> Min => new();
            public Reactive<T> Max => new();
        }
    }
}