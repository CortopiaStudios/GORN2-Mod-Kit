// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity.Singletons.Types;
using Cortopia.Scripts.Reactivity.Utils;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveStateComparer : MonoBehaviour, INamedBindableReactiveOwner
    {
        [SerializeField]
        private string reactiveName;
        [SerializeField]
        private StateGlobalVariable stateVariable;
        [SerializeField]
        private NumericalComparisonOperator conditionOperator;
        [SerializeField]
        private string conditionState;

        private readonly ReactiveSource<bool> _conditionMet = new(false);
        private int _conditionInt;
        private ReactiveSubscription _subscribes;

        [UsedImplicitly]
        public Reactive<bool> ConditionMet => this._conditionMet.Reactive;

        private void Awake()
        {
            this._conditionInt = this.stateVariable.States.IndexOf(this.conditionState);
            this._subscribes = this.stateVariable.Variable.Reactive.OnValue(this.CheckCondition);
        }

        private void OnDestroy()
        {
            this._subscribes.Dispose();
        }

        private void OnValidate()
        {
            if (this.stateVariable && this.stateVariable.States.IndexOf(this.conditionState) < 0)
            {
                Debug.LogError($"Condition state <{this.conditionState}> is invalid on ReactiveStateComparer", this);
            }
        }

        public string GetName(string propertyName)
        {
            return string.IsNullOrWhiteSpace(this.reactiveName) ? "" : $"{this.reactiveName}.{propertyName}";
        }

        private void CheckCondition(int arg)
        {
            this._conditionMet.Value = arg.CompareTo(this._conditionInt, this.conditionOperator);
        }
    }
}