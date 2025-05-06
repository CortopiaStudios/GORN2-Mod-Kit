// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;
using UnityEngine.Events;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Gameplay
{
    public class DamageContext : MonoBehaviour
    {
        [HelpBox("This script functions as a bridge between a weapon and the victim. Sent downstream through the code, it can report back to the weapon how much" +
                 "damage was dealt, or report who was responsible to the victim. Note that it won't do much by itself - damage-causing components such as Piercing or" +
                 "Sharpness must connect to it for it to send and receive data!")]
        [SerializeField]
        private BoundValue<Object[]> handsGrabbingWeapon;

        [Tooltip("If this object is a projectile, that script must be connected here for DamageContext to be able to function correctly when the projectile is launched.")]
        [SerializeField]
        private Projectile projectile;

        [Space]
        [SerializeField]
        private UnityEvent<DamageEvent> onDamage;
        [SerializeField]
        private UnityEvent<DamageEvent> onDamageByPlayer;
        [SerializeField]
        private UnityEvent<DamageEvent> onKill;
        [SerializeField]
        private UnityEvent<DamageEvent> onKillByPlayer;

        public Reactive<IntegerCounter> Kills => default;
        public Reactive<IntegerCounter> Damages => default;
        public Reactive<float> LatestDamage => default;
        public Reactive<Damage.DamageType> LatestDamageType => default;
        public Reactive<int> LatestDamageTypeAsInt => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void OnKill(DamageEvent e)
        {
            throw new NotImplementedException();
        }

        public void OnDamage(DamageEvent damageEvent)
        {
            throw new NotImplementedException();
        }
    }
}