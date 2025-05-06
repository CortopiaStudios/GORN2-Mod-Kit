// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(CanvasGroup))]
    public sealed class ReactorCanvasGroup : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> alpha;

        private CanvasGroup _canvasGroup;
        private ReactiveSubscription _subscription;

        private CanvasGroup CanvasGroup => this._canvasGroup ??= this.GetComponent<CanvasGroup>();

        private void OnEnable()
        {
            this._subscription &= this.alpha.Reactive.OnValue(this.SetAlpha);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void SetAlpha(float a)
        {
            this.CanvasGroup.alpha = a;
            bool fullyVisible = Mathf.Approximately(this.CanvasGroup.alpha, 1f);
            this.CanvasGroup.interactable = fullyVisible;
            this.CanvasGroup.blocksRaycasts = fullyVisible;
        }
    }
}