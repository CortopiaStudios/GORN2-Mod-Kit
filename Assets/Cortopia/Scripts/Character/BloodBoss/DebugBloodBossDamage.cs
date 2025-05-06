// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BloodBoss
{
    public class DebugBloodBossDamage : MonoBehaviour
    {
        [SerializeField]
        private bool doDamage;

        [SerializeField]
        private List<WritableBoundValue<bool>> scabs;

        private void Update()
        {
            throw new NotImplementedException();
        }

        public void OnDamage(DamageEvent damageEvent)
        {
            Debug.Log("damage: " + damageEvent.Damage.Value);
        }

        public void OnDamage()
        {
            Debug.Log("damage stab! ");
        }
    }
}