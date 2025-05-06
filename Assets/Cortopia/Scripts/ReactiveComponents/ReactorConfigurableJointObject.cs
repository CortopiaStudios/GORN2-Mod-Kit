// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.ReactiveComponents
{
    [RequireComponent(typeof(Rigidbody))]
    public class ReactorConfigurableJointObject : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> configurableJointObject;
        [SerializeField]
        private Transform anchorPose;
        [SerializeField]
        private BoundValue<Transform> connectedAnchorPose;
        [SerializeField]
        private bool enableCollisions = true;
        [SerializeField]
        private bool syncPose;
        [SerializeField]
        [Tooltip("Should the connected Configurable Joint Object be teleported to the anchored pose when connected?")]
        private bool teleportOnConnect;
        [SerializeField]
        [Tooltip("Put the joint component on either this object (when unchecked) or on the Configurable Joint Object (when checked) when the objects should be connected.")]
        private bool addJointOnJointObject;
        [SerializeField]
        private BoundValue<ConfigurableJoint> jointSettings;
        [SerializeField]
        private UnityEvent<ConfigurableJoint> onJointCreated;

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