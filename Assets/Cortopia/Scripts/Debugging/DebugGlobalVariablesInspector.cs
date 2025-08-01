// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Cortopia.Scripts.Debugging
{
    public class DebugGlobalVariablesInspector : MonoBehaviour
    {
        [SerializeField]
        private Transform itemParent;
        [SerializeField]
        private Transform itemPrefab;
        [SerializeField]
        private TMP_Dropdown sortByDropdown;
        [SerializeField]
        private ScrollRect scrollRect;

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