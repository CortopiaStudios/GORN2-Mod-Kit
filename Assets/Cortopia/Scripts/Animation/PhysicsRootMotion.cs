// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using JetBrains.Annotations;
using Oculus.Interaction;
using Unity.XR.CoreUtils;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace Cortopia.Scripts.Animation
{
    public class PhysicsRootMotion : MonoBehaviour
    {
        [SerializeField]
        [Interface(typeof(IRootMotion))]
        [CanBeNull]
        private MonoBehaviour rootMotion;
        [SerializeField]
        private Transform animationRootBone;
        [SerializeField]
        private ConfigurableJoint hipJoint;
        [Space]
        [SerializeField]
        private BoundValue<float> animationForceAlpha = new(1);
        [Space]
        [SerializeField]
        private BoundValue<bool> applyDownwardForce = new(true);
        [SerializeField]
        private Vector3 hipAnimationPositionScale = Vector3.one;
        [SerializeField]
        private Vector3 hipAnimationRotationScale = Vector3.one;
        [Space]
        [SerializeField]
        private BoundValue<Vector3> addAngularVelocity;
        [Space]
        [Tooltip("Which bones to apply the root motion force on. If the collection is empty the force is applied on all bones.")]
        [SerializeField]
        private BoneID.Id[] applyForceOnBones = {BoneID.Id.LeftUpLeg, BoneID.Id.LeftLeg, BoneID.Id.LeftFoot, BoneID.Id.RightUpLeg, BoneID.Id.RightLeg, BoneID.Id.RightFoot};

        public Reactive<Vector3> LocalVelocityError => new();

        public Reactive<float> LocalVelocityErrorSqrMagnitude => new();

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        public void RefreshRigidbodies()
        {
            throw new NotImplementedException();
        }

        private static Vector3 SnapVector(Vector3 v)
        {
            Vector3 w = v.Abs();
            var s = new Vector3(w.x > w.y && w.x > w.z ? 1f : 0f, w.y > w.x && w.y > w.z ? 1f : 0f, w.z > w.y && w.z > w.x ? 1f : 0f);
            return Vector3.Scale(s, v);
        }

#if UNITY_EDITOR
        [ContextMenu("Snap root joint axes")]
        private void SnapRootJointAxes()
        {
            Undo.RecordObject(this.hipJoint, "Snap root joint axes");
            Quaternion localRotation = this.hipJoint.transform.localRotation;
            Vector3 worldAxis = localRotation * this.hipJoint.axis;
            Vector3 worldSecondaryAxis = localRotation * this.hipJoint.secondaryAxis;
            Quaternion localRotationInverse = Quaternion.Inverse(localRotation);
            this.hipJoint.axis = localRotationInverse * SnapVector(worldAxis);
            this.hipJoint.secondaryAxis = localRotationInverse * SnapVector(worldSecondaryAxis);
        }

        [ContextMenu("Snap root joint axes", true)]
        private bool SnapRootJointAxesValidation()
        {
            return !Application.isPlaying && this.hipJoint;
        }
#endif
    }
}