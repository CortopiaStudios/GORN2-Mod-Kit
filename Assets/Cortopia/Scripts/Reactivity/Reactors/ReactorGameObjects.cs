// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorGameObjects : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> active;
        [SerializeField]
        private GameObject[] gameObjects;
        [SerializeField]
        private bool inverseBoundRelation;

        private ReactiveSubscription _subscription;

        private void OnEnable()
        {
            this._subscription = this.active.Reactive.OnValue(this.OnActiveChanged);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void OnActiveChanged(bool isActive)
        {
            foreach (GameObject go in this.gameObjects)
            {
                if (!go)
                {
                    continue;
                }

                go.SetActive(isActive ^ this.inverseBoundRelation);
            }
        }
    }
}