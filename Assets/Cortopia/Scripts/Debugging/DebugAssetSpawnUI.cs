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
    public class DebugAssetSpawnUI : MonoBehaviour
    {
        [SerializeField]
        private string addressablesLabel;
        [SerializeField]
        private TMP_Dropdown assetsDropdown;
        [SerializeField]
        private float spawnDistanceFromCamera;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void SpawnSelectedAsset()
        {
            throw new NotImplementedException();
        }
    }
}