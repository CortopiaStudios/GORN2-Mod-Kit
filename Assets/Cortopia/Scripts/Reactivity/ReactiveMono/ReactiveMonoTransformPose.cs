// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.ReactiveMono
{
    public class ReactiveMonoTransformPose : MonoBehaviour
    {
        public Reactive<float> PositionX => new();
        public Reactive<float> PositionY => new();
        public Reactive<float> PositionZ => new();
        public Reactive<Vector3> Position => new();
        public Reactive<Quaternion> Rotation => new();
        public Reactive<Pose> Pose => new();

        private void Start()
        {
        }

        private void Update()
        {
        }
    }
}