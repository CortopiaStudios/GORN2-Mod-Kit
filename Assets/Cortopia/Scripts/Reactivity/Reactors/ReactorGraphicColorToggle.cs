// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.UI;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorGraphicColorToggle : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<bool> toggleValue;
        [SerializeField]
        private Color trueColor;
        [SerializeField]
        private Color falseColor;
        [SerializeField]
        private AnimationCurve interpolationCurve;
        [SerializeField]
        private float animationTime;

        private float _elapsedTime;
        private Graphic _graphic;
        private Color _startingColor;

        private ReactiveSubscription _subscription;
        private bool _visualToggleValue;

        private void Update()
        {
            if (this._elapsedTime > this.animationTime)
            {
                return;
            }

            Color targetColor = this._visualToggleValue ? this.trueColor : this.falseColor;

            this._elapsedTime += Time.deltaTime;
            float delta = this.interpolationCurve.Evaluate(this._elapsedTime / this.animationTime);

            this._graphic.color = Vector4.Lerp(this._startingColor, targetColor, delta);
        }

        private void OnEnable()
        {
            this._graphic ??= this.GetComponent<Graphic>();
            this._startingColor = this._graphic.color;
            this._subscription = this.toggleValue.Reactive.OnValue(this.Handler);
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }

        private void Handler(bool obj)
        {
            if (this._visualToggleValue == obj)
            {
                return;
            }

            this._startingColor = this._graphic.color;
            this._elapsedTime = 0f;
            this._visualToggleValue = obj;
        }

        [ContextMenu("Set True Color")]
        private void SetToTrueTranslation()
        {
            this._graphic ??= this.GetComponent<Graphic>();
            this._graphic.color = this.trueColor;
        }

        [ContextMenu("Set False Color")]
        private void SetToFalsePosition()
        {
            this._graphic ??= this.GetComponent<Graphic>();
            this._graphic.color = this.falseColor;
        }
    }
}