// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Interaction;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Props
{
    public class PowerUpBottleCork : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Grabbable> corkGrabbable;
        [SerializeField]
        private BoundValue<GameObject> corkPrefab;

        public Reactive<bool> FlaskIsOpen => default;

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