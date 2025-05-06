// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Interaction;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class GrabbableSlot : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> isActive;
        [Tooltip("An object to be forcibly grabbed. This will ignore all rules, including isActive, but it must still contain a Grabbable!")]
        [SerializeField]
        private BoundValue<GameObject> objectToForceGrab;

        [Space]
        [Tooltip(
            "Whether or not to use a specific grab method when retrieving the object from the Slot. See the tooltips on the Grabbable component for more info about the different methods.")]
        [SerializeField]
        private bool useOverrideGrabMethod;
        [Tooltip(
            "The type of grab to attempt when the player retrieves the Grabbable from the Slot. See the tooltips on the Grabbable component for more info about the different methods.")]
        [SerializeField]
        private Grabbable.SingleGrabMethod preferredGrabMethod;

        [Header("Collision")]
        [SerializeField]
        private bool isObjectCollisionEnabled;

        [Header("SlotActivation")]
        [SerializeField]
        [Tooltip("If provided, the player needs to grab the activation grabbable with one hand to be able to interact with objects attached to this grabbable slot.")]
        // [CanBeNull]
        private Grabbable playerActivationGrabbable;

        [Space]
        [Tooltip("The trigger that finds Grabbables to put into this slot. This field is automatically set once a trigger connects to this slot.")]
        [ReadOnly]
        [SerializeField]
        // ReSharper disable once NotAccessedField.Local
        private GrabbableSlotTrigger trigger;

        public Reactive<GrabbableRoot> AttachedGrabbableRoot => default;
        public Reactive<GrabbableRoot> DetachedGrabbableRoot => default;
        public bool CanBeGrabbedByPlayer => default;
        public Reactive<GameObject> AttachedGameObject => default;
        public Reactive<bool> HasAttachedGameObject => default;
        public Rigidbody AttachedRigidbody => default;

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