// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.ReactiveComponents
{
    public class ReactiveFindBone : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Transform> reference;
        [SerializeField]
        private BoneID.Id boneID;

        public Reactive<Transform> Result => default;
    }
}