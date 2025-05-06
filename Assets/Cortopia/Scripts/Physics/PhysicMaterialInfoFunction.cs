// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    [Serializable]
    public class PhysicMaterialInfo
    {
        public bool isPenetrable;
    }

    [CreateAssetMenu(menuName = "Cortopia/Physics/PhysicMaterialInfoFunction")]
    public class PhysicMaterialInfoFunction : ScriptableObject
    {
        [SerializeField]
        private PhysicMaterialInfo @default;
        [SerializeField]
        private Mapping[] mappings;

        [Serializable]
        private struct Mapping
        {
            public PhysicMaterial physicMaterial;
            [Space]
            public PhysicMaterialInfo info;
        }
    }
}