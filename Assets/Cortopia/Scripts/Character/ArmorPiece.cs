// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.BehaviorTree.Spawning;
using Cortopia.Scripts.CleanupSystem;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using Unity.XR.CoreUtils;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Character
{
    [RequireComponent(typeof(Rigidbody))]
    public class ArmorPiece : GravesBehaviour
    {
        [SerializeField]
        private ArmorLocation location;

        [SerializeField]
        [ReadOnly]
        private Collider[] colliders;

        [SerializeField]
        [CanBeNull]
        private GameObject armorRoot;

        [SerializeField]
        private BoundValue<bool> isActive = new(true);

        [SerializeField]
        private CleanupQueue armorCleanupQueue;

        [SerializeField]
        private UnityEvent onCleanup;

        [HideInInspector]
        public ArmorSlot connectedSlot;

        public Reactive<bool> IsActive => new();

        public ArmorLocation Location => new();

        public Reactive<bool> IsConnected => new();

        public GameObject GameObject => new();

        private void Start()
        {
            throw new NotImplementedException();
        }

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void SetCleanupEnabled(bool value)
        {
            throw new NotImplementedException();
        }

        public void Clean()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}