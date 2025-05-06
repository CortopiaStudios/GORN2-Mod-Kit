// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorMonoBehaviours : MonoBehaviour
    {
        [SerializeField]
        private new BoundValue<bool> enabled;
        [SerializeField]
        private MonoBehaviour[] monoBehaviours;
        [SerializeField]
        private bool inverseBoundRelation;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.enabled.Reactive.OnValue(this.OnActiveChanged);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnActiveChanged(bool isActive)
        {
            bool setActive = isActive ^ this.inverseBoundRelation;
            
            foreach (MonoBehaviour monoBehaviour in this.monoBehaviours)
            {
                monoBehaviour.enabled = setActive;
            }
        }
    }
}