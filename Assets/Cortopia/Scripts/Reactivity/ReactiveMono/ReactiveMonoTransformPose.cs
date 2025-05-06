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
        private readonly ReactiveSource<Pose> _pose = new(UnityEngine.Pose.identity);

        private Transform _transform;

        public Reactive<float> PositionX => this._pose.Reactive.Select(x => x.position.x);

        public Reactive<float> PositionY => this._pose.Reactive.Select(x => x.position.y);

        public Reactive<float> PositionZ => this._pose.Reactive.Select(x => x.position.z);
        public Reactive<Vector3> Position => this._pose.Reactive.Select(x => x.position);
        public Reactive<Quaternion> Rotation => this._pose.Reactive.Select(x => x.rotation);
        public Reactive<Pose> Pose => this._pose.Reactive;

        private void Start()
        {
            this._transform = this.transform;
        }

        private void Update()
        {
            if (this._transform.hasChanged)
            {
                Transform transform1 = this.transform;
                this._pose.Value = new Pose(transform1.position, transform1.rotation);
                this._transform.hasChanged = false;
            }
        }
    }
}