// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity
{
    public class ReactiveCollisionCheck : MonoBehaviour
    {
        [SerializeField]
        private CollisionType collisionMode;
        [SerializeField]
        [Tooltip("Leave empty to trigger collision on everything")]
        private GameObject targetObject;

        private readonly ReactiveSource<float> _collisionVelocity = new(0f);
        private readonly ReactiveSource<bool> _isColliding = new(false);

        [UsedImplicitly]
        public Reactive<bool> IsColliding => this._isColliding.Reactive;

        [UsedImplicitly]
        public Reactive<float> CollisionVelocity => this._collisionVelocity.Reactive;

        private void OnDisable()
        {
            this._isColliding.Value = false;
        }

        private void OnCollisionEnter(Collision other)
        {
            if (this.collisionMode is not CollisionType.Collision)
            {
                return;
            }

            if (!this.IsTargetObject(other.collider))
            {
                return;
            }

            using (ReactiveTransaction.Create())
            {
                this._collisionVelocity.Value = other.relativeVelocity.magnitude;
                this._isColliding.Value = true;
            }
        }

        private void OnCollisionExit(Collision other)
        {
            if (this.collisionMode is not CollisionType.Collision)
            {
                return;
            }

            if (!this.IsTargetObject(other.collider))
            {
                return;
            }

            this._isColliding.Value = false;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (this.collisionMode is not CollisionType.Trigger)
            {
                return;
            }

            if (this.IsTargetObject(other))
            {
                this._isColliding.Value = true;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (this.collisionMode is not CollisionType.Trigger)
            {
                return;
            }

            if (this.IsTargetObject(other))
            {
                this._isColliding.Value = false;
            }
        }

        private bool IsTargetObject(Collider other)
        {
            if (!this.targetObject)
            {
                return true;
            }

            Rigidbody attachedRigidbody = other.attachedRigidbody;
            return other.gameObject == this.targetObject || (attachedRigidbody && attachedRigidbody.gameObject == this.targetObject);
        }

        private enum CollisionType
        {
            Trigger,
            Collision
        }
    }
}