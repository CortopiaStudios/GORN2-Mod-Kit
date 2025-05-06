// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    public struct DamageEvent
    {
        public Limb Limb;
        [CanBeNull]
        public Damage Damage;
    }

    [DisallowMultipleComponent]
    public class DamageEventListener : MonoBehaviour
    {
        [SerializeField]
        private bool sendMessagesDownwards;

        public UnityEvent<DamageEvent> onDamage = new();

        [SerializeField]
        private UnityEvent onImpactDamage;
        [SerializeField]
        private UnityEvent onSlashDamage;
        [SerializeField]
        private UnityEvent onStabDamage;
        [SerializeField]
        private UnityEvent onSliceDamage;
        [SerializeField]
        private UnityEvent onTearDamage;
        [SerializeField]
        private UnityEvent onCrushDamage;
        [SerializeField]
        private UnityEvent onFireDamage;
        [Space]
        [SerializeField]
        private TagEventPair[] taggedImpactDamageEvents;
        [SerializeField]
        private TagEventPair[] taggedSlashDamageEvents;
        [SerializeField]
        private TagEventPair[] taggedStabDamageEvents;
        [SerializeField]
        private TagEventPair[] taggedSliceDamageEvents;
        [SerializeField]
        private TagEventPair[] taggedTearDamageEvents;
        [SerializeField]
        private TagEventPair[] taggedCrushDamageEvents;
        [SerializeField]
        private TagEventPair[] taggedFireDamageEvents;

        public Reactive<float> LastDamageValue => default;

        public Reactive<DamageEvent> OnDamage => default;

        public Reactive<float> OnDamageValue => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void RegisterDamageEventListener(Component component)
        {
            throw new NotImplementedException();
        }

        public void UnregisterDamageEventListener(Component component)
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private struct TagEventPair
        {
            public string tag;
            public UnityEvent @event;
        }
    }
}