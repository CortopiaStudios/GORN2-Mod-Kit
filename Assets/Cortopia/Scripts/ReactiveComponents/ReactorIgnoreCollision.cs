// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactorIgnoreCollision : MonoBehaviour
    {
        [HelpBox("Ignore the collision between two game objects. Once the colliders are ignored they will stay that way.")]
        [SerializeField]
        private BoundValue<GameObject> gameObject1;
        [SerializeField]
        private BoundValue<GameObject> gameObject2;

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