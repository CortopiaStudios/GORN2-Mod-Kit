// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Linq;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class MultiReactorGameObject : MonoBehaviour
    {
        [SerializeField]
        private ReactiveConfig[] reactiveConfigs;
        [SerializeField]
        private GameObject reactingGameObject;

        private bool _doSubscribe;
        private ReactiveSubscription _subscription;

        private void Update()
        {
            if (!this._doSubscribe)
            {
                return;
            }

            this._doSubscribe = false;
            this._subscription = this.reactiveConfigs.Select(x => x.GetReactive())
                .Combine()
                .Select(x => x.All(y => y))
                .DistinctUntilChanged()
                .OnValue(this.OnActiveChanged);
        }

        private void OnEnable()
        {
            this._doSubscribe = true;
        }

        private void OnDisable()
        {
            this._doSubscribe = false;
            this._subscription.Dispose();
        }

        private void OnValidate()
        {
            if (this.reactingGameObject && this.reactingGameObject.transform.parent != this.transform)
            {
                Debug.LogWarning($"{this.GetType().Name}: Property \"GameObject\" ({this.name}) must be a direct child of self!", this.transform.gameObject);
            }
        }

        private void OnActiveChanged(bool isActive)
        {
            if (this.reactingGameObject)
            {
                this.reactingGameObject.SetActive(isActive);
            }
        }

        [Serializable]
        private class ReactiveConfig
        {
            public BoundValue<bool> isActiveSource;
            public bool inverseBoundRelation;

            public Reactive<bool> GetReactive()
            {
                if (this.inverseBoundRelation)
                {
                    return this.isActiveSource.Reactive.Select(x => !x);
                }

                return this.isActiveSource.Reactive;
            }
        }
    }
}