// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Gameplay;
using Cortopia.Scripts.Reactivity;
using Unity.XR.CoreUtils;
using UnityEngine;

namespace Cortopia.Scripts.Gore
{
    [RequireComponent(typeof(CapsuleCollider))]
    public class Sharpness : WeaponTrait
    {
        [SerializeField]
        private DamageContext damageContext;

        [Space]
        [SerializeField]
        [Tooltip("The maximum radius the intersected vertices of a slicable mesh to actually trigger a slice.")]
        private BoundValue<float> maxSliceRadius = new(0.3f);

        [Space]
        [SerializeField]
        private BoundValue<float> slashAngleThreshold = new(60);
        [SerializeField]
        private BoundValue<float> slashSpeedThreshold = new(5);
        [SerializeField]
        private float sliceSpeedThreshold = 10;

        [Space]
        [SerializeField]
        private float slashDamage = 20;

        [Space]
        [SerializeField]
        [Tooltip("If you want sharp edges that are round you should add the other related sharpness components here to make sure the slash and slicing works correctly.")]
        private Sharpness[] connectedSharpnesses;

        [SerializeField]
        [Tooltip("The joint damper amount when slashing.")]
        private float damper = 1000;
        [SerializeField]
        private float slashDuration = 0.1f;

        public Reactive<float> MaxSliceRadius => default;

        protected override void OnEnable()
        {
            throw new NotImplementedException();
        }

        protected override void OnDisable()
        {
            throw new NotImplementedException();
        }

        private void OnCollisionEnter(Collision collision)
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
        
        private static (Vector3 p1, Vector3 p2) CapsuleColliderLocalEndPoints(CapsuleCollider capsuleCollider)
        {
            Vector3 capsuleDirectionVector = ConvertCapsuleDirectionToVector(capsuleCollider.direction);
            float capsuleRadius = capsuleCollider.radius;
            float radiusScale = (Vector3.one - capsuleDirectionVector).MaxComponent();
            float heightScale = capsuleDirectionVector.sqrMagnitude;
            float capsuleLengthFromRadius = radiusScale * 2 * capsuleRadius;
            float capsuleLengthFromHeight = heightScale * capsuleCollider.height;
            float capsuleLength = Mathf.Max(capsuleLengthFromRadius, capsuleLengthFromHeight);

            Vector3 center = capsuleCollider.center;
            Vector3 p1 = center + capsuleLength * capsuleDirectionVector / 2;
            Vector3 p2 = center - capsuleLength * capsuleDirectionVector / 2;
            return (p1, p2);
        }

        private (Vector3 point1, Vector3 point2) EndPoints
        {
            get
            {
                var endPoints = CapsuleColliderLocalEndPoints(this.GetComponent<CapsuleCollider>());
                Vector3 spherePosition1 = this.transform.TransformPoint(endPoints.p1);
                Vector3 spherePosition2 = this.transform.TransformPoint(endPoints.p2);
                return (spherePosition1, spherePosition2);
            }
        }

        private static Vector3 ConvertCapsuleDirectionToVector(int direction)
        {
            return direction switch
            {
                0 => Vector3.right,
                1 => Vector3.up,
                2 => Vector3.forward,
                _ => throw new ArgumentOutOfRangeException(nameof(direction), direction, null)
            };
        }

        private void OnDrawGizmosSelected()
        {
            const float interval = 0.01f;
            const float length = 0.05f;

            (Vector3 spherePosition1, Vector3 spherePosition2) = this.EndPoints;

            Gizmos.color = Color.blue;
            Gizmos.DrawLine(spherePosition1, spherePosition2);

            int count = Mathf.FloorToInt((spherePosition1 - spherePosition2).magnitude / interval) + 1;
            var ray = new Ray(spherePosition1, (spherePosition2 - spherePosition1).normalized);
            for (int i = 0; i < count; i++)
            {
                Gizmos.color = Color.blue;
                Vector3 point = ray.GetPoint(i * interval);
                var capsuleCollider = this.GetComponent<CapsuleCollider>();
                Gizmos.DrawRay(point, length * this.transform.TransformDirection(ConvertCapsuleDirectionToVector((capsuleCollider.direction + 1) % 3)));

                Gizmos.color = Color.yellow;
                Gizmos.DrawRay(point, length * 0.5f * this.transform.TransformDirection(ConvertCapsuleDirectionToVector((this.GetComponent<CapsuleCollider>().direction + 2) % 3)));
            }
        }

    }
}