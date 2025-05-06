// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Interaction
{
    public class MirrorPhysics : GravesBehaviour
    {
        [SerializeField]
        [Tooltip("If the object physics tend to break, using an average local pose for the slave object can reduce glitching")]
        private bool enableSmoothProxyPose;

        [Tooltip(
            "Due to the low physics time-step, for an object to move smoothly while grabbed it needs to be temporarily offset while rendering and then reset immediately afterwards to prevent the physics from breaking." +
            "\n\nInsert any Transform that needs this type of smoothing here." +
            "\n\n(Note that if the main Grabbable object has other Grabbable objects connected to it via joints, they can also be added here but only Locked motion and angular motion are supported!)\n")]
        [SerializeField]
        private MirrorPhysicsTransforms[] transformMirrors;

        [Tooltip(
            "If the object has any GrabbableSlot, they can be added here, as GrabbableSlots need some special care. These will also be offset during rendering and reset afterwards.")]
        [SerializeField]
        private MirrorPhysicsTransforms[] grabbableSlotMirrors;

        [Tooltip(
            "If the object has any internal interactive components (like the bowstring on a bow), some objects may have to retain their offset position after rendering " +
            "so that the player can interact with the object while in the offset position. These objects don't need a proxy, as they rely completely on their parent Transform for positioning." +
            "That also means that they must have a local position of (0, 0, 0)." +
            "\n\nTo avoid bugs, these objects should be as simple as possible and disconnected from any direct physical interactions.")]
        [SerializeField]
        private Transform[] interactiveObjects;

        [SerializeField]
        [Tooltip("Text mesh pro objects are expected to sit on a base transform that has a local position 0, that should be put in here")]
        private Transform textTransform;

        [SerializeField]
        [Tooltip(
            "Ara trails only updates in regular update, so this needs to be offset constantly during grabbing. This transform is expected to have a local position of 0")]
        private Transform araTrailTransform;

        [SerializeField]
        private LineRendererTransformTarget lineRendererTransformTarget;

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void LateUpdate()
        {
            throw new NotImplementedException();
        }

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }

    [Serializable]
    public class MirrorPhysicsTransforms
    {
        public Transform proxy;
        public Transform slave;
    }
}