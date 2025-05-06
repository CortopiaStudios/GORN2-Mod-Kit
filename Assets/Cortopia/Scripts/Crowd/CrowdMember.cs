// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.VertexAnimation;
using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    public class CrowdMember : MonoBehaviour
    {
        [SerializeField]
        private Vector2 uvTiling;
        [SerializeField]
        private Color materialColor;
        [SerializeField]
        private VertexAnimationDescription animationDescription;
        [SerializeField]
        private int textureSheetColumns;
        [SerializeField]
        private int textureSheetRows;

        public int SpawnedPositionIdx { get; set; }

        public void SetNewPlace(CrowdPlacementTweaking place)
        {
            throw new NotImplementedException();
        }
    }
}