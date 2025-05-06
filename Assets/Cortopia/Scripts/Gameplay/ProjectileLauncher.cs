// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Gameplay
{
    public class ProjectileLauncher : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> launchFromPrefab;

        [Tooltip("This is intended for rapid launching of many projectiles. Don't connect this directly to a prefab!" +
                 "\nMake sure to use ReactiveAddressableResource (or something like it) to load it for you first, or it won't work in builds!")]
        [SerializeField]
        private BoundValue<GameObject> projectilePrefab;

        [Tooltip("How many more projectile prefabs can be launched? Set to -1 for infinite projectiles.")]
        [SerializeField]
        private WritableBoundValue<int> remainingAmmo = new(-1);

        [SerializeField]
        private BoundValue<bool> shouldCostAmmo;

        [Tooltip("This event will trigger every time a launch is attempted while remainingAmmo == 0.")]
        [SerializeField]
        private UnityEvent onOutOfAmmo;

        [Space]
        [Tooltip("This is intended for single launches of specific projectiles, like a bow and arrow." +
                 "\nBefore you can launch, inject a new GameObject instance into the projectile instance field.")]
        [SerializeField]
        private BoundValue<GameObject> projectileInstance;

        [Tooltip("The Joint to use for connecting the Projectile. This can be left null if the projectile is fired immediately and not manually prepared before-hand.")]
        // [CanBeNull]
        [SerializeField]
        private ConfigurableJoint projectileAttachmentJoint;

        [Header("Triggers")]
        [Tooltip("Triggering this will prepare a new projectile. This in only relevant when launching from prefabs and you want to see the projectile before launch!")]
        [SerializeField]
        private BoundValue<IntegerCounter> prepareRequest;

        [Tooltip("Triggering this will launch a projectile. If launching from prefabs, you don't need to prepare a projectile before-hand, but you can!")]
        [SerializeField]
        private BoundValue<IntegerCounter> launchRequest;

        [Header("Launch Settings")]
        [SerializeField]
        private BoundValue<Vector3> localLaunchDirection = new(Vector3.forward);
        [SerializeField]
        private BoundValue<float> launchPower;

        [SerializeField]
        private BoundValue<float> forceMin;

        [SerializeField]
        private BoundValue<float> forceMax;

        [SerializeField]
        private BoundValue<bool> shouldDamagePlayer;

        [SerializeField]
        private BoundValue<bool> isGrabbedByPlayer;

        [Space]
        [SerializeField]
        private UnityEvent onBeforeProjectileConnected;

        [Header("Editor")]
        [SerializeField]
        private bool debugPauseOnLaunch;

        public Reactive<bool> HasPreparedProjectile => default;

        public Reactive<Projectile> PreparedProjectile => default;

        public Reactive<Projectile> LaunchedProjectile => default;

        public Reactive<GameObject> PreparedProjectileGameObject => default;

        public Reactive<IntegerCounter> OnLaunchProjectile => default;

        public Reactive<int> RemainingAmmo => default;

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
    }
}