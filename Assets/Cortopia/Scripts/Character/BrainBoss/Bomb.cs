// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    [RequireComponent(typeof(Rigidbody))]
    public class Bomb : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> explosionFx;
        [SerializeField]
        private float lifetimeAfterCollision;
        [SerializeField]
        private float fxTime;
        [SerializeField]
        private float maxLifetime = 20.0f;
        [SerializeField]
        private float parryCooldown = 0.5f;
    }
}