// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.ReactiveMono
{
    public class ReactivePositionInverseLerp : MonoBehaviour
    {
        [SerializeField]
        private Vector3 minPosition;
        [SerializeField]
        private Vector3 maxPosition;

        private readonly ReactiveSource<float> _inverseLerp = new(0f);

        [UsedImplicitly]
        public Reactive<float> InverseLerpValue => this._inverseLerp.Reactive;
        
        private void Update()
        {
            this._inverseLerp.Value = InverseLerp(this.transform.localPosition, this.minPosition, this.maxPosition);
        }

        private static float InverseLerp(Vector3 value, Vector3 a, Vector3 b)
        {
            Vector3 ab = b - a;
            Vector3 av = value - a;
            return Mathf.Clamp01(Vector3.Dot(av, ab) / Vector3.Dot(ab, ab));
        }
    }
}