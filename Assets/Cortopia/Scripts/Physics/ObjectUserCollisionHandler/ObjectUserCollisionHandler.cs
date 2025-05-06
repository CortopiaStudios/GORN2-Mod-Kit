// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Physics.ObjectUserCollisionHandler
{
    public class ObjectUserCollisionHandler : MonoBehaviour
    {
        public enum RestrictionLevel
        {
            None,
            Limited,
            Disabled
        }

        [HelpBox(
            "This script is intended to handle collisions for itself all of its children, grandchildren, and so on. Spawners are fine, but you should not have separate items start the game under this Transform!" +
            "\n\nFirst, handlers can connect to each other to share what specific colliders they ignore. They will also ignore each other when doing this." +
            "\n\nSecond, handlers can receive requests for overall restrictions and they will prioritize what's deemed most important. " +
            "If the restriction level is Disabled, all colliders are set to be triggers that exclude all layers. If the level is Limited, colliders are still set to be triggers, but you can specify what layers to still listen for." +
            "\n\nFinally, handlers can receive specific colliders to ignore. These are shared when handlers are connected, but the handler that received the call to ignore still holds ownership over it.")]
        [Space]
        [Tooltip("The hands currently grabbing the object. This is used to ignore collisions between the object and whatever is holding it.")]
        [SerializeField]
        private BoundValue<Object[]> currentGrabbingHands;

        [Tooltip(
            "If the object can become attached to another object (like an arrow attaching to a bow), collision between the objects is not always handled automatically (like for hands or GrabbableSlot). " +
            "In that situation, you can slot in the connected Transform here - this script will then look for another ObjectUserCollisionHandler on or above that Transform " +
            "and connect to it, making them share what specific colliders they ignore. This can also be useful when you have two grabbables on the same object, so both ignore collisions when only one is grabbed." +
            "\n\nThe connection is automatically two-way and you're not allowed to make circular connections. This means you can chain as many handlers as you want.")]
        [SerializeField]
        private BoundValue<Transform> connectedTransform;

        [Tooltip("How long to wait before resuming collisions with the hand that released this object?")]
        [SerializeField]
        private BoundValue<float> onHandReleaseStopIgnoreDelay;

        [Space]
        [Tooltip("The layers to be allowed via triggers while collision is limited. You may want the Player layer here, for example, to keep the object grabbable.")]
        [SerializeField]
        private LayerMask limitedCollisionMask;

        public Reactive<bool> IsGrabbed => default;

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