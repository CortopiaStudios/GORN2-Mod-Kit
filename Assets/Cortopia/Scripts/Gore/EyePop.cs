// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Character;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gore
{
    public class EyePop : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> canPopEyes;

        [SerializeField]
        private Eye leftEye;

        [SerializeField]
        private Eye rightEye;

        [SerializeField]
        private LayerMask ignoreCollisionCharacter;

        [SerializeField]
        private float minimumForceEyeHang = 1000.0f;

        [SerializeField]
        private float minimumForceEyeShot = 2000.0f;

        [SerializeField]
        private float eyePopForceMultiplier = 0.0001f;

        [Range(0.0f, 1.0f)]
        [SerializeField]
        private float probability;

        [Range(0.0f, 90.0f)]
        [SerializeField]
        private float degreesBackHitDoubleEyePop;

        [SerializeField]
        private BoundValue<ArmorPiece> helmet;

        public Reactive<bool> RightEyeIsAttached => default;

        public Reactive<bool> LeftEyeIsAttached => default;

        private void LateUpdate()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        public void SetLeftEyeJoint(ConfigurableJoint joint)
        {
            throw new NotImplementedException();
        }

        public void SetRightEyeJoint(ConfigurableJoint joint)
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private class Eye
        {
            public Transform eyeLocalPosition;
            public Transform root;
            public Rigidbody physics;
            public Transform opticNerveStart;
            public Transform opticNerveEnd;
            public GameObject eyeStringMesh;
            public Transform eyeStringMeshEnd;
            public ConfigurableJoint jointSettings;

            [HideInInspector]
            public Collider collider;
            [HideInInspector]
            public ConfigurableJoint joint;
            public ReactiveSource<bool> isAttached = new(true);
            public bool isAttachedNonReactive = true;
        }
    }
}