// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class CharacterScaleController : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<GameObject> headGraphics;

        [SerializeField]
        private BoundValue<GameObject> headPhysics;

        [Tooltip("For organs that are not childed to the character body.")]
        [SerializeField]
        private List<BoundValue<GameObject>> spawnedOrgans;

        public Reactive<float> Scale => new();
        public Reactive<float> InverseScale => new();

        public void Init()
        {
            throw new NotImplementedException();
        }
    }
}