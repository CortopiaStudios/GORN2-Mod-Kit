// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Events;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class GrabbableSlotTrigger : MonoBehaviour
    {
        [SerializeField]
        private float radius;

        [SerializeField]
        private LayerMask acceptedLayers;

        [SerializeField]
        private string acceptedTag;

        [Space]
        [SerializeField]
        private GrabbableSlot[] slots;
        [SerializeField]
        private EventPassthroughGameObject onPlayerWillinglyReleasedObject;

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