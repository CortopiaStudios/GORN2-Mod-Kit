// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;
#if UNITY_EDITOR
#endif

namespace Cortopia.Scripts.Utils
{
    public class Follow : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> target;
        [SerializeField]
        private UpdateMode updateMode = UpdateMode.LateUpdate;
        [SerializeField]
        private Settings settings = Settings.Position | Settings.Rotation;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        private enum UpdateMode
        {
            Update,
            LateUpdate,
            FixedUpdate
        }

        [Flags]
        private enum Settings
        {
            [UsedImplicitly]
            Position = PositionX | PositionY | PositionZ,
            PositionX = 1 << 1,
            PositionY = 1 << 2,
            PositionZ = 1 << 3,
            Rotation = RotationX | RotationY | RotationZ,
            RotationX = 1 << 4,
            RotationY = 1 << 5,
            RotationZ = 1 << 6,
            Scale = ScaleX | ScaleY | ScaleZ,
            ScaleX = 1 << 7,
            ScaleY = 1 << 8,
            ScaleZ = 1 << 9
        }

        private struct Mapping
        {
            public Transform Target;
            public Transform Follower;
            public Settings Settings;
        }
    }
}