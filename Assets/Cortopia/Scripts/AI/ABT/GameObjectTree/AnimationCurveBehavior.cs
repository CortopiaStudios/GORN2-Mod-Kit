// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.AI.ABT.Nodes;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.AI.ABT.GameObjectTree
{
    [AddComponentMenu("BehaviorTree/Animation/AnimationCurveBehavior")]
    public class AnimationCurveBehavior : BehaviorTreeBase
    {
        [SerializeField]
        private WritableBoundValue<float> value;
        [SerializeField]
        private BoundValue<float> startValue;
        [SerializeField]
        private BoundValue<float> endValue;
        [SerializeField]
        private BoundValue<float> time;
        [SerializeField]
        private AnimationCurve rampCurve;
        private float _endTime;
        private float _startTime;

        protected override IBehaviorTree CreateBehaviorTree()
        {
            return new BtSequence("RampValue")
            {
                new BtAction("Set start time", () =>
                {
                    this._startTime = Time.time;
                    this._endTime = this._startTime + this.time.Reactive.Value;
                }),
                new BtRepeater(this.DebugName, BtRepeater.Mode.RepeatOnFail)
                {
                    new BtSequence("Sequence")
                    {
                        new BtAction("Update value", () =>
                        {
                            float currentTimeRatio = (Time.time - this._startTime) / this.time.Reactive.Value;
                            this.value.SetValue(Mathf.Lerp(this.startValue.Reactive.Value, this.endValue.Reactive.Value, this.rampCurve.Evaluate(currentTimeRatio)));
                        }),
                        new BtCondition("Check for counter increase", () => Time.time > this._endTime)
                    }
                }
            };
        }
    }
}