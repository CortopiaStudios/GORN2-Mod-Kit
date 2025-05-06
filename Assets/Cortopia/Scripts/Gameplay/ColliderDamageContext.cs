// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    [RequireComponent(typeof(Collider))]
    [DisallowMultipleComponent]
    public class ColliderDamageContext : MonoBehaviour
    {
        [SerializeField]
        private DamageContext damageContext;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }
    }
}