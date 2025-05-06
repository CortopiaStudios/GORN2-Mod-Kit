// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using TMPro;
using UnityEngine;

namespace Cortopia.Scripts.Debugging
{
    public class DebugConsole : MonoBehaviour
    {
        [SerializeField]
        private TMP_Text textField;
        [SerializeField]
        private int logHistoryCount = 12;
        [SerializeField]
        private Color logColor = Color.white;
        [SerializeField]
        private Color warningColor = Color.yellow;
        [SerializeField]
        private Color errorColor = Color.red;

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