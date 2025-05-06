// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Character.BrainBoss
{
    [RequireComponent(typeof(Rigidbody))]
    public class TetherAnchor : MonoBehaviour
    {
        [UsedImplicitly]
        public static List<TetherAnchor> AllAnchors = new();
        [SerializeField]
        private BoundValue<bool> isValid;

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