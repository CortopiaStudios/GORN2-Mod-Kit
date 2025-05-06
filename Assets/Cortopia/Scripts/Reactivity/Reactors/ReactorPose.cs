// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorPose : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Pose> pose;
        [SerializeField]
        private Space space = Space.World;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.pose.Reactive.OnValue(p =>
            {
                if (this.space == Space.World)
                {
                    this.transform.SetPositionAndRotation(p.position, p.rotation);
                }
                else
                {
                    this.transform.SetLocalPositionAndRotation(p.position, p.rotation);
                }
            });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}