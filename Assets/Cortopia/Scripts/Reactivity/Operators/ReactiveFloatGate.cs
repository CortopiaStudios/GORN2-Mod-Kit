// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatGate : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float> input;
        [SerializeField]
        private BoundValue<float> threshold;
        [SerializeField]
        private BoundValue<float> @return;

        private readonly ReactiveSource<bool> _output = new(false);

        private ReactiveSubscription _subscription;

        public Reactive<float> Input => this.input.Reactive;
        public Reactive<float> Threshold => this.threshold.Reactive;
        public Reactive<float> Return => this.@return.Reactive;
        public Reactive<bool> Output => this._output.Reactive;

        private void OnEnable()
        {
            var gates = this.threshold.Reactive.Combine(this.@return.Reactive).Select(t => (threshold: t.Item1, @return: t.Item2, direction: !(t.Item1 < t.Item2)));
            this._subscription &= this._output.Reactive.DistinctUntilChanged()
                .Combine(this.input.Reactive, gates)
                .OnValue(t =>
                {
                    (bool state, float value, (float threshold, float @return, bool direction) g) = t;
                    switch (state)
                    {
                        case false:
                            bool atThreshold = !(g.direction ? value < g.threshold : value > g.threshold);
                            if (atThreshold)
                            {
                                this._output.Value = true;
                            }

                            break;
                        case true:
                            bool belowReturn = g.direction ? value < g.@return : value > g.@return;
                            if (belowReturn)
                            {
                                this._output.Value = false;
                            }

                            break;
                    }
                });
        }

        private void OnDisable()
        {
            this._subscription.Dispose();
        }
    }
}