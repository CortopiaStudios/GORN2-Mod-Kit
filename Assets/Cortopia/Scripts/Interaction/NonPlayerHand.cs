// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using Cortopia.Scripts.Interaction.Interfaces;

namespace Cortopia.Scripts.Interaction
{
    [RequireComponent(typeof(CustomSocketInteractor))]
    public class NonPlayerHand : MonoBehaviour, IHand
    {
        [Space]
        [Tooltip("The object to be grabbed by the XR Socket Interactor. This must contain a Grabbable! The interactor will only work through the use of this field.")]
        [SerializeField]
        private BoundValue<GameObject> objectToGrab;

        [Space]
        [Tooltip("The Rigidbody that grabbed objects should be jointed to.")]
        [SerializeField]
        private Rigidbody connectionBody;

        [Header("Joint Settings")]
        [SerializeField]
        private ConfigurableJoint freeSingleGrabJointSettings;
        [SerializeField]
        private ConfigurableJoint handleSingleGrabJointSettings;
        [SerializeField]
        private HandednessValue handedness;

        public Reactive<GameObject> GrabbedObject => default;

        public Reactive<bool> HasGrabbedObject => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void ReleaseHeldObject()
        {
            throw new NotImplementedException();
        }
    }
}