// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveTrigger : GravesBehaviour
    {
        [SerializeField]
        private LayerMask checkLayers;

        [SerializeField]
        private List<string> tags = new();

        public Reactive<bool> IsTriggering => default;

        public Reactive<GameObject> TriggeringObject => default;

        public Reactive<IntegerCounter> TriggerCounter => default;

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}