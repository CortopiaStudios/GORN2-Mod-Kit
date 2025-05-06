// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    public class Glue : GravesBehaviour
    {
        [SerializeField]
        private ConfigurableJoint jointSettings;
        [SerializeField]
        private Rigidbody rootGlueBody;
        [SerializeField]
        private Collider[] glueColliders;
        [SerializeField]
        private string[] ignoreTags;
        [SerializeField]
        private LayerMask characterLayer = 1 << 6;
        [Space]
        [SerializeField]
        private float breakForceObjects = 900.0f;
        [SerializeField]
        private float breakTorqueObjects = 900.0f;
        [Space]
        [SerializeField]
        private float breakForceCharacters = 200.0f;
        [SerializeField]
        private float breakTorqueCharacters = 200.0f;
        [Space]
        [SerializeField]
        private float breakForceEnvironment = 500.0f;
        [SerializeField]
        private float breakTorqueEnvironment = 500.0f;
        [Space]
        [SerializeField]
        private Collider[] preGluedColliders;
        [Space]
        [Header("Movement joint break settings")]
        // [CanBeNull]
        [SerializeField]
        private PoseTracker poseTracker;
        [SerializeField]
        private float speedThreshold;
        [SerializeField]
        [Tooltip("Movement joint break settings is applied after threshold speed has been held for this time")]
        private float movementSettingsDelay;
        [Space]
        [SerializeField]
        private float breakForceObjectsMovement = 100_000.0f;
        [SerializeField]
        private float breakTorqueObjectsMovement = 100_000.0f;
        [SerializeField]
        [Space]
        private float breakForceCharactersMovement = 20_000.0f;
        [SerializeField]
        private float breakTorqueCharactersMovement = 20_000.0f;
        [Space]
        [SerializeField]
        private float breakForceEnvironmentMovement = 500.0f;
        [SerializeField]
        private float breakTorqueEnvironmentMovement = 500.0f;
        [Space]
        [SerializeField]
        private UnityEvent onAttach;
        [SerializeField]
        private UnityEvent onDetach;

        public Reactive<bool> HasGluedObject => default;

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}