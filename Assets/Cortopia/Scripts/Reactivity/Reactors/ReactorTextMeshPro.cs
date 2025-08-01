﻿// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using TMPro;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(TMP_Text))]
    public class ReactorTextMeshPro : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<string> text;

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }
    }
}