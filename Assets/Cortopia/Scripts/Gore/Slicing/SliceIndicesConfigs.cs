// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using UnityEngine;

namespace Cortopia.Scripts.Gore.Slicing
{
    [CreateAssetMenu(menuName = "Cortopia/SliceIndicesConfigs")]
    public class SliceIndicesConfigs : ScriptableObject
    {
        // [CanBeNull]
        public int[] startVertices;
        // [CanBeNull]
        public bool[] noPathFindingVertices;

        public List<string> keysConnectedMeshAreas = new();

        public List<IntListWrapper> valuesConnectedMeshAreas = new();

        public void Initialize()
        {
            throw new NotImplementedException();
        }

        [Serializable]
        public class IntListWrapper
        {
            public List<int> values = new();
        }
    }
}