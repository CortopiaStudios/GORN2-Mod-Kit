// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Crowd
{
    public class CrowdPlacementTweaking : MonoBehaviour
    {
        private static readonly int Color1 = Shader.PropertyToID("_Color");

        [SerializeField]
        private Color placeColor = Color.white;

        public Color PlaceColor
        {
            get => this.placeColor;
            set
            {
                this.placeColor = value;
                this.OnValidate();
            }
        }

        private void OnValidate()
        {
            if (!this.gameObject.TryGetComponent(out Renderer r))
            {
                return;
            }

            var propertyBlock = new MaterialPropertyBlock();
            r.GetPropertyBlock(propertyBlock);
            this.UpdateMaterialPropertyBlock(propertyBlock);
            r.SetPropertyBlock(propertyBlock);
        }

        public void UpdateMaterialPropertyBlock(MaterialPropertyBlock propertyBlock)
        {
            propertyBlock.SetColor(Color1, this.placeColor);
        }
    }
}