// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using TMPro;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    [RequireComponent(typeof(TMP_Text))]
    public class ReactorTextMeshProAlpha : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> alpha;

        private bool _doSubscribe;
        private ReactiveSubscription _subscription;
        private TMP_Text _text;

        private TMP_Text Text => this._text ??= this.GetComponent<TMP_Text>();

        private void OnEnable()
        {
            this._subscription = this.alpha.Reactive.OnValue(f => { this.Text.color = new Color(this.Text.color.r, this.Text.color.g, this.Text.color.b, f); });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}