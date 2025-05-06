// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Core
{
    public class GameConstants : MonoBehaviour
    {
        [Header("Damage")]
        [SerializeField]
        private BoundValue<float> impactDamageScale = new(1);
        [Tooltip("This is also used for lava damage.")]
        [SerializeField]
        private BoundValue<float> impactDamageCooldownDuration = new(0.2f);
        [SerializeField]
        private BoundValue<float> impactFallDamageMassScale = new(1);
        [SerializeField]
        private BoundValue<float> impactMinimumDamage = new(1);
        [SerializeField]
        private float impactThrowDamageScale = 1f;
        [SerializeField]
        private float knockOutDamage = 30f;

        [Header("Armor")]
        [SerializeField]
        private LayerMask impactProtectionLayer;

        [Header("Lava")]
        [SerializeField]
        private float lavaDamage = 5f;
        [Tooltip(
            "How much force is applied to a limb hitting lava, to try to crush it. A greater number means fewer hits needed before crushing. Ignores the Limb's minimum force threshold.")]
        [SerializeField]
        private float lavaCrushForce = 2000f;
        [SerializeField]
        private float lavaBounceMultiplier = 19f;
        [Tooltip("An NPCs health/maxHealth is inversely plotted on this curve to get a modifier which is used to determine the strength of each bounce on lava.")]
        [SerializeField]
        private AnimationCurve lavaBounceStrengthOverCharacterHealth;

        [Header("Cleanup")]
        [SerializeField]
        [Tooltip("Only objects outside this distance from camera will be cleaned")]
        private BoundValue<float> minCleanupDistance = new(10);
        [SerializeField]
        [Tooltip("Only objects outside this angle from camera will be cleaned")]
        private BoundValue<float> minCleanupAngle = new(60);
        [SerializeField]
        [Tooltip("Backwards offset from camera from which cleaning angle is calculated")]
        private BoundValue<float> backwardOffset = new(1);

        [Header("Grabbables")]
        [SerializeField]
        [Tooltip("The distance a weapon for example can be stretched until being reset to its original pose to avoid buggy stretchy weapons")]
        private BoundValue<float> resetJointWhenStretchedDistance = new(1);

        [Header("Tearing")]
        [SerializeField]
        [Tooltip("The amount of fatigue a limb takes before tearing off. Roughly related to the amount of time the limb is being stretched")]
        private BoundValue<float> tearFatigue = new(.85f);

        [Header("AimThrowAssist")]
        [SerializeField]
        private BoundValue<int> playerSettingsRangeMinValue = new(0);
        [SerializeField]
        private BoundValue<int> playerSettingsRangeMaxValue = new(100);

        [Header("Physics")]
        [Tooltip("How far ahead piercing objects RayCast against the collider they think they've hit. At high speeds Unity expands colliders to ensure collisions, so this helps to prevent that from causing false positives.")]
        [SerializeField]
        private float piercingRayCastDistance = 0.1f;
        [SerializeField]
        private PhysicMaterialInfoFunction physicMaterialInfo;
    }
}