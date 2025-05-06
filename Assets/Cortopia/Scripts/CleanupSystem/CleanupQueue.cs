// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.CleanupSystem
{
    [CreateAssetMenu(menuName = "Cortopia/Cleanup System Queue")]
    public class CleanupQueue : ScriptableObject
    {
        [SerializeField]
        private int minCount;
        [SerializeField]
        private int maxCount;
        [SerializeField]
        private float lifetime;

        public int MinCount
        {
            get => throw new NotImplementedException();
            set => throw new NotImplementedException();
        }

        public int MaxCount
        {
            get => throw new NotImplementedException();
            set => throw new NotImplementedException();
        }

        public float Lifetime => throw new NotImplementedException();

        [ContextMenu("Clear queue")]
        public void Clear()
        {
            throw new NotImplementedException();
        }
    }
}