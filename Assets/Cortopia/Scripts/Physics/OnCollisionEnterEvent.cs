// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Utils;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Physics
{
    // OnCollisionEnterEvent allows the user to listen to collision events on only the children colliders on this component or
    // all colliders if its attached to an object with a rigidbody component.

    [DisallowMultipleComponent]
    public class OnCollisionEnterEvent : MonoBehaviour
    {
        [HelpBox("This component will only receive collision from the rigidbody this object is part of and will ignore colliders in child bodies.")]
        [Space]
        [SerializeField]
        private UnityEvent<Collision> collisionEnter = new();
    }
}