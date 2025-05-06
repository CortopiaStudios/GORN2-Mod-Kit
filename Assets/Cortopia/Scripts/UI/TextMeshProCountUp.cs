// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using TMPro;
using UnityEngine;

namespace Cortopia.Scripts.UI
{
    public class TextMeshProCountUp : MonoBehaviour
    {
        public TextMeshProUGUI textMeshPro;
        [SerializeField]
        private BoundValue<int> targetNumber;
        [SerializeField]
        private BoundValue<int> startNumber;
        [SerializeField]
        private bool shouldStartManually;
        public float countSpeed = 1.0f;
        public float startDelay = 2.0f;

        public ReactiveSource<bool> IsCounting => default;

        public ReactiveSource<float> CountingProgress => default;

        private void Start()
        {
            throw new NotImplementedException();
        }

        public void StartCounting()
        {
            throw new NotImplementedException();
        }
    }
}