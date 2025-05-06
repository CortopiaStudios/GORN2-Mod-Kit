// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorSetRotation : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Quaternion> rotation;
        [SerializeField]
        private Space transformSpace;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription &= this.rotation.Reactive.OnValue(rot =>
            {
                switch (this.transformSpace)
                {
                    case Space.World:
                        this.transform.rotation = rot;
                        break;
                    case Space.Self:
                        this.transform.localRotation = rot;
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