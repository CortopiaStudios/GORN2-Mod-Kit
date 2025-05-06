// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity.Singletons;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Cortopia.Scripts.Debugging
{
    public class DebugBossJumpUI : MonoBehaviour
    {
        [SerializeField]
        private GlobalVariable<int> waveReachedVariable;
        [SerializeField]
        private GlobalVariable<bool> saluteWindowIsActiveVariable;
        [SerializeField]
        private GlobalVariable<bool> bossFightHasStartedVariable;
        [SerializeField]
        private TMP_Dropdown dropdown;
        [SerializeField]
        private Button button;

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