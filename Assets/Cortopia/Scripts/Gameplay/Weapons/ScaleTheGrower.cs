// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay.Weapons
{
    public class TheGrowerScaler : MonoBehaviour
    {
        [SerializeField]
        private float minScale = 1f;
        [SerializeField]
        private float maxScale = 1f;
        [SerializeField]
        private float startingScale = 1f;
        [SerializeField]
        private Rigidbody[] rigidbodies;

        public Reactive<float> CurrentScale => default;

        public Reactive<bool> IsMaxScale => default;

        public void Scale(float scale)
        {
            throw new NotImplementedException();
        }
    }
}