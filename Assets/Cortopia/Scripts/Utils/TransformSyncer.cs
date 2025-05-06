// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    public class TransformSyncer : MonoBehaviour
    {
        [HelpBox("This component exposes methods for syncing the transform of this game object with the target transform. Scale is ignored.")]
        [SerializeField]
        private BoundValue<Transform> target;

        public void SyncPose()
        {
            throw new NotImplementedException();
        }
    }
}