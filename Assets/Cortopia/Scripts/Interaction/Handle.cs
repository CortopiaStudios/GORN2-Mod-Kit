// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Interaction
{
    public class Handle : MonoBehaviour
    {
        [SerializeField]
        private float handleLength;

        [SerializeField]
        private bool allowInvertForward;

        [SerializeField]
        [Tooltip("The direction towards the tip of the weapon.")]
        private Vector3 tipDirection = Vector3.up;

        [Header("Fixed Grab Offset")]
        [Tooltip("If the object is grabbed using the Fixed Grab method (applied when force-grabbed or grabbed by NPC), offset the handle's rotation by this value.")]
        [SerializeField]
        private Vector3 fixedGrabRotationOffset;

        [Tooltip("See the fixedGrabRotationOffset tooltip for more info. This offset is in addition to that one, but only applied to the left hand.")]
        [SerializeField]
        private Vector3 fixedGrabRotationOffsetLeftHand;

        [Header("NPC Offset")]
        [Tooltip("In certain circumstances, an NPC may need to hold an object differently than the player. This lets you offset the overall grab rotation.")]
        [SerializeField]
        private Vector3 npcGrabRotationOffset;
        [Tooltip("In certain circumstances, an NPC may need to hold an object differently than the player. This lets you adjust the height of the grab position.")]
        [SerializeField]
        private float npcGrabPosYOffset;
    }
}