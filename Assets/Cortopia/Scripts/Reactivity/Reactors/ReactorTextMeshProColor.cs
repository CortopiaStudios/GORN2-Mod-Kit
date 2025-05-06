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
    public class ReactorTextMeshProColor : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<Color> color;

        private ReactiveSubscription _subscription;
        private TMP_Text _text;

        private TMP_Text Text => this._text ??= this.GetComponent<TMP_Text>();

        private void OnEnable()
        {
            this._subscription = this.color.Reactive.OnValue(f => this.Text.color = f);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}