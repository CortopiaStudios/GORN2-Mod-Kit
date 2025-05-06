// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    public class CrowdPlacement : MonoBehaviour
    {
        public CrowdPlacementTweaking[] Placements { get; private set; }

        private void Awake()
        {
            this.UpdatePlacementList();
        }

        public void UpdatePlacementList()
        {
            this.Placements = this.GetComponentsInChildren<CrowdPlacementTweaking>(true);
        }

        public void ShufflePlacementList()
        {
            int n = this.Placements.Length;
            while (n > 1)
            {
                int k = Random.Range(0, n--);
                (this.Placements[n], this.Placements[k]) = (this.Placements[k], this.Placements[n]);
            }
        }
    }
}