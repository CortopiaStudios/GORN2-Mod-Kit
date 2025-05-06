// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorIntGameObject : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<int> active;
        [SerializeField]
        private new GameObject gameObject;
        [SerializeField]
        private BoundValue<int> reactiveTargetInt;
        [SerializeField]
        private bool inverseBoundRelation;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.active.Reactive.Combine(this.reactiveTargetInt.Reactive)
                .DistinctUntilChanged()
                .Select((newValue, reactiveTarget) => newValue == reactiveTarget)
                .OnValue(this.OnActiveChanged);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnValidate()
        {
            if (this.gameObject && this.gameObject.transform.parent != this.transform)
            {
                Debug.LogWarning($"{this.GetType().Name}: Property \"GameObject\" ({this.name}) must be a direct child of self!", this.transform.gameObject);
            }
        }

        private void OnActiveChanged(bool isActive)
        {
            if (this.gameObject)
            {
                this.gameObject.SetActive(isActive ^ this.inverseBoundRelation);
            }
        }
    }
}