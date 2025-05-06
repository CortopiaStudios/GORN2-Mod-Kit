// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.Character.BrainBoss
{
    public class BrainBossAttackLaser : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> laserTrigger;
        [SerializeField]
        private BoundValue<Transform> followPlayer;
        [Space]
        [SerializeField]
        public BrainBossEye eye;
        [Space]
        [Header("Laser")]
        [SerializeField]
        private LineRenderer line;
        [SerializeField]
        private Transform playerDamage;
        [SerializeField]
        private float laserMaxLength;
        [SerializeField]
        [Tooltip("Factor for how much a new target position should lie between the following player position and the eye forward")]
        private float followPlayerFactor;
        [SerializeField]
        [Tooltip("The maximum speed when moving towards a new target position")]
        private float laserMaxSpeed;
        [SerializeField]
        private float impactFxCoolDown;
        [SerializeField]
        private GameObject emitFX;
        [SerializeField]
        private GameObject trailFX;
        [SerializeField]
        private AssetReferenceGameObject impactFX;
        [SerializeField]
        private LayerMask environmentLayer;
        [SerializeField]
        private LayerMask playerDamageLayer;
        [SerializeField]
        private LayerMask characterLayer;

        private void Update()
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
    }
}