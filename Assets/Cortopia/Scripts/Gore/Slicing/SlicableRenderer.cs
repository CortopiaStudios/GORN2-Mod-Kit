// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Gore.Slicing
{
    [RequireComponent(typeof(SkinnedMeshRenderer))]
    public class SlicableRenderer : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Place spheres on a local position from the main skinned mesh renderer in the area where path finding should start")]
        // [CanBeNull]
        private Transform startPathFindingTransform;
        [SerializeField]
        [Tooltip(
            "Place copies of renderers on a local position from the main skinned mesh renderer, each connectedMeshRenderer object need to have the same name as the connected mesh object")]
        private MeshRenderer[] connectedMeshRenderers;
        [SerializeField]
        [Tooltip("Child copies of renderers on a local position from the main skinned mesh renderer, each child with a mesh renderer will be accounted for")]
        private Transform noPathFindingAreas;
        [Space]
        [SerializeField]
        private SliceIndicesConfigs sliceIndicesConfigs;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }
    }
}