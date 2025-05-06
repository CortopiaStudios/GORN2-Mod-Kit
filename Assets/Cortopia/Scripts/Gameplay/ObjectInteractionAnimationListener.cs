// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    [RequireComponent(typeof(Animator))]
    public class ObjectInteractionAnimationListener : MonoBehaviour
    {
        [Space]
        [HelpBox("This script connects animation events to interactions with a held object, for example by signaling when to pull a bowstring.")]
        [SerializeField]
        private BoundValue<bool> isActive;

        [Tooltip("The IK Weight value to output during the grab event.")]
        [SerializeField]
        private BoundValue<float> ikWeightGrabbed;

        [Tooltip("The IK Weight value to output right after the grab event ends.")]
        [SerializeField]
        private BoundValue<float> ikWeightReleased;

        public Reactive<bool> ShouldGrabSecondaryGrabPointWithOtherHand => default;

        public Reactive<float> IKWeight => default;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void IdleGrabStart()
        {
            throw new NotImplementedException();
        }

        public void GrabStart()
        {
            throw new NotImplementedException();
        }

        public void GrabRelease()
        {
            throw new NotImplementedException();
        }
    }
}