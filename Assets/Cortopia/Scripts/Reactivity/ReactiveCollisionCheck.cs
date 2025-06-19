// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveCollisionCheck : MonoBehaviour
    {
        [SerializeField]
        private CollisionType collisionMode;
        [SerializeField]
        [Tooltip("Leave empty to trigger collision on everything")]
        private GameObject targetObject;

        [UsedImplicitly]
        public Reactive<bool> IsColliding => new();

        [UsedImplicitly]
        public Reactive<float> CollisionVelocity => new();

        private void OnDisable()
        {
        }

        private enum CollisionType
        {
            Trigger,
            Collision
        }
    }
}