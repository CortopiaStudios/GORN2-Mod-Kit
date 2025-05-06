// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Events;
#if UNITY_EDITOR
#endif

namespace Cortopia.Scripts.Gore.Slicing
{
    [DisallowMultipleComponent]
    public class Slicable : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<SkinnedMeshRenderer> skinnedMeshRenderer;
        [SerializeField]
        private BoundValue<Material> sliceMaterial;
        [SerializeField]
        private BoundValue<Material> capMaterial;
        [SerializeField]
        private Rigidbody rootBody;
        [SerializeField]
        [CanBeNull]
        private Rigidbody headBody;
        [Space]
        [SerializeField]
        private UnityEvent<SliceInfo> onSliced;

        [Space]
        [SerializeField]
        private Transform decapitationPlane;
        [SerializeField]
        private float decapitationAngle = 30;
        [SerializeField]
        private float decapitationDistanceToPlane = 0.5f;
        [SerializeField]
        private float decapitationDistanceToCenter = 0.5f;

        private void Start()
        {
            throw new NotImplementedException();
        }

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        private void OnDestroy()
        {
            throw new NotImplementedException();
        }
    }
}