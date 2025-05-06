// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    [CreateAssetMenu(fileName = "new ModelBaker", menuName = "Cortopia/VertexAnimation/ModelBaker", order = 400)]
    public class VertexAnimationModelBaker : ScriptableObject
    {
        // Input.
        public GameObject model;
        public AnimationPoseSettings[] animationPoses;
        [Range(1, 60)]
        public int fps = 24;
        public bool applyRootMotion;
        public bool includeInactive;
        public bool generateNormalMap;

        public bool applyAnimationBounds = true;
        public bool generatePrefab = true;

        public Texture diffuse;
        public bool useTextureTileSheet;
        public int textureSheetColumns;
        public int textureSheetRows;
        public Shader materialShader;
        private VertexAnimationDescription _description;
        private Material _material;
        private Mesh[] _meshes;
        private Texture2D _normalMap;

        // Output.
        private Texture2D _positionMap;

        private void OnValidate()
        {
            if (this.materialShader == null)
            {
                this.materialShader = Shader.Find("VATShader");
            }
        }
    }
}