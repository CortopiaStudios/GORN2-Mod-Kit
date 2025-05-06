// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Filtering;

namespace Cortopia.Scripts.Interaction
{
    [RequireComponent(typeof(Rigidbody))]
    public class Grabbable : XRBaseInteractable, IXRSelectFilter
    {
        public enum SingleGrabMethod
        {
            Hybrid,
            Dynamic,
            Fixed
        }

        [Space]
        [Tooltip(
            "The type of grab to perform by default - eg when the player has one hand directly touching the Grabbable. In other situations other grab methods may still be used." +
            "\n\nNOTE: this is only used for Grabbables with selectMode set to Single!" +
            "\n\nHybrid: the Grabbable is moved to the same position as the hand, but rotation is relatively free." +
            "\n\nDynamic: if the Grabbable has a handle, the Grabbable is moved so the closest point on the handle touches the hand, if not then the hand and Grabbable are jointed together without moving anything." +
            "\n\nFixed: the Grabbable is moved to the same position+rotation as the hand.")]
        [SerializeField]
        private SingleGrabMethod preferredSingleGrabMethod = SingleGrabMethod.Hybrid;

        // [CanBeNull]
        [SerializeField]
        private Handle handle;

        [Space]
        [Tooltip("Two-handed grabbing is currently triggered by a weapon employing some specific AttackType-indexes. For any other object, this is irrelevant.")]
        [SerializeField]
        private NpcTwoHandGrabSettings npcTwoHandGrabSettings;

        [Header("Custom")]
        [SerializeField]
        private ConfigurableJoint singleGrabJointSettings;

        [SerializeField]
        private ConfigurableJoint npcSingleGrabJointSettings;

        [SerializeField]
        private ConfigurableJoint multipleGrabJointSettings;

        [SerializeField]
        [Tooltip("For objects that are grabbed by two hands, does it takes one or two hands to aim throw the object?")]
        private bool aimThrowWithTwoHands;

        [SerializeField]
        [Tooltip("Scale the rigidbody mass with this value whenever it's being grabbed. Only applied when grabbed by the player.")]
        private float grabMassScale = 1;

        [SerializeField]
        [Tooltip("The grab joint mass scale when the grabbing the object while it's piercing an object. Only applied when grabbed by the player.")]
        private float grabMassScaleWhenPiercing = -1;

        [SerializeField]
        [Tooltip("Automatically disable Grabbable if this game object also has a Limb component that is alive.")]
        private bool disableWhenLimbIsAlive = true;

        [Header("Player Scale")]
        [Tooltip("If the player is below this scale, the player will override this Grabbable's Joint Setting and Select Mode. Set to 0 to effectively disable.")]
        [SerializeField]
        private float smallPlayerOverrideSettingsThreshold = 0.5f;

        [Tooltip(
            "If the player is above this scale, the player will override this Grabbable's Joint Setting and Select Mode. Set to some really large value to effectively disable.")]
        [SerializeField]
        private float bigPlayerOverrideSettingsThreshold = 1.5f;

        [Tooltip("Should the collider on the player hand be enabled while grabbing this object or not.")]
        [SerializeField]
        private bool enablePlayerHandCollider;

        public Reactive<Joint> GrabJoint => default;

        public Reactive<Joint> NpcTwoHandGrabSecondJoint => default;

        public Reactive<bool> Grabbed => default;

        public Reactive<bool> IsForceGrabbed => default;

        public Reactive<bool> GrabbedByLeftHand => default;

        public Reactive<bool> GrabbedByRightHand => default;

        public Reactive<bool> GrabbedByNonPlayer => default;

        public Reactive<bool> GrabbedByPlayer => default;

        // IXRSelectFilter
        public bool Process(IXRSelectInteractor interactor, IXRSelectInteractable interactable)
        {
            throw new NotImplementedException();
        }

        // IXRSelectFilter
        public bool canProcess => throw new NotImplementedException();

        public void SetIsForceGrabbed(bool isForceGrabbed)
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private class NpcTwoHandGrabSettings
        {
            // [CanBeNull]
            [SerializeField]
            private Transform grabPointLeft;

            [Tooltip(
                "How far below the grab point to place the hand if the character's scale is 1.2. The hand's vertical position is interpolated (without clamping) between this value and the maximum, using the scale.")]
            [Range(-1f, 0f)]
            [SerializeField]
            private float grabPointLeftScaledHeightMin;

            [Tooltip(
                "How far above the grab point to place the hand if the character's scale is 0.8. The hand's vertical position is interpolated (without clamping) between this value and the minimum, using the scale.")]
            [Range(0f, 1f)]
            [SerializeField]
            private float grabPointLeftScaledHeightMax;

            [Space]
            // [CanBeNull]
            [SerializeField]
            private Transform grabPointRight;

            [Tooltip(
                "How far below the grab point to place the hand if the character's scale is 0.8. The hand's vertical position is interpolated (without clamping) between this value and the maximum, using the scale.")]
            [Range(-1f, 0f)]
            [SerializeField]
            private float grabPointRightScaledHeightMin;

            [Tooltip(
                "How far above the grab point to place the hand if the character's scale is 1.2. The hand's vertical position is interpolated (without clamping) between this value and the minimum, using the scale.")]
            [Range(0f, 1f)]
            [SerializeField]
            private float grabPointRightScaledHeightMax;

            [Space]
            // [CanBeNull]
            [SerializeField]
            private Joint jointSettingsLeft;

            // [CanBeNull]
            [SerializeField]
            private Joint jointSettingsRight;
        }
    }
}