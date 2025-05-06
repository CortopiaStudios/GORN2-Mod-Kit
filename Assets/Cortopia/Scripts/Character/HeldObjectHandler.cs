// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Character
{
    public class HeldObjectHandler : MonoBehaviour
    {
        [HelpBox("This script handles the connection between hands and held objects - like, what is the current attack type, or what object should a hand actually grab?")]
        [Space]
        [SerializeField]
        private HandData rightHand;

        [SerializeField]
        private HandData leftHand;

        [SerializeField]
        private RightSpawnerObjectData rightObjectData;

        [SerializeField]
        private LeftSpawnerObjectData leftObjectData;

        [Space]
        [Header("Variables")]
        [SerializeField]
        private BoundValue<float> unarmedAttackDistance;

        [SerializeField]
        private BoundValue<int> bowAttackType;

        [SerializeField]
        private BoundValue<int> bazookaAttackType;

        [SerializeField]
        private BoundValue<int> nailGunAttackType;

        [SerializeField]
        private BoundValue<int> twoHandAttackType;

        [SerializeField]
        private BoundValue<int> twoHandStabAttackType;

        public Reactive<int> CurrentMainWeapon => new();
        public Reactive<int> CurrentAttackType => new();
        public Reactive<float> CurrentAttackDistance => new();
        public Reactive<GameObject> RightHandGrabObj => new();
        public Reactive<GameObject> LeftHandGrabObj => new();
        public Reactive<bool> IsUnarmed => new();
        public Reactive<bool> IsUsingRangedWeapon => new();
        public Reactive<bool> IsUsingBow => new();
        public Reactive<bool> IsUsingBazooka => new();
        public Reactive<bool> IsUsingNailGun => new();
        public Reactive<bool> IsUsingTwoHandedMeleeWeapon => new();
        public Reactive<bool> IsRightSpawnerObjectTwoHanded => new();

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private class HandData
        {
            [SerializeField]
            private BoundValue<bool> isAlive;
            [SerializeField]
            private BoundValue<GameObject> grabbedObj;
            [SerializeField]
            private UnityEvent forceReleaseGrabbedObj;

            public Reactive<bool> IsAlive => new();
            public Reactive<GameObject> GrabbedObj => new();
        }

        [Serializable]
        private class LeftSpawnerObjectData
        {
            [SerializeField]
            private BoundValue<GameObject> primaryGrabPoint;
            [Tooltip("The secondary grab point is currently only used on the left-hand object and is intended for two-handed ranged weapons.")]
            [SerializeField]
            private BoundValue<GameObject> secondaryGrabPoint;
            [Tooltip("If true, and the right hand is freely available, it will try to grab the secondary grab point. This is used for two-handed ranged weapons.")]
            [SerializeField]
            private BoundValue<bool> shouldGrabSecondaryGrabPointWithRightHand;
            [SerializeField]
            private BoundValue<int> attackType;
            [SerializeField]
            private BoundValue<float> attackDistance;

            public Reactive<GameObject> PrimaryGrabPoint => new();
            public Reactive<GameObject> SecondaryGrabPoint => new();
            public Reactive<bool> ShouldGrabSecondaryGrabPointWithRightHand => new();
            public Reactive<int> AttackType => new();
            public Reactive<float> AttackDistance => new();
        }

        [Serializable]
        private class RightSpawnerObjectData
        {
            [SerializeField]
            private BoundValue<GameObject> grabPoint;
            [SerializeField]
            private BoundValue<int> attackType;
            [SerializeField]
            private BoundValue<float> attackDistance;

            public Reactive<GameObject> GrabPoint => new();
            public Reactive<int> AttackType => new();
            public Reactive<float> AttackDistance => new();
        }
    }
}