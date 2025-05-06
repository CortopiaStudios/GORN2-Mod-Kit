// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorSetPosition : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Vector3> position;
        [SerializeField]
        private Space transformSpace;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription &= this.position.Reactive.OnValue(pos =>
            {
                switch (this.transformSpace)
                {
                    case Space.World:
                        this.transform.position = pos;
                        break;
                    case Space.Self:
                        this.transform.localPosition = pos;
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }
            });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}