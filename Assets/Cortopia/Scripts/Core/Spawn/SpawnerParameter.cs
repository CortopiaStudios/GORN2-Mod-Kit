// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Core.Spawn
{
    public abstract class SpawnerParameter : MonoBehaviour, INamedBindableReactiveOwner
    {
        public enum Direction
        {
            InOut,
            In,
            Out
        }

        public string parameterName;
        public Direction direction;
        public abstract Type ParameterType { get; }
        public abstract string GetName(string propertyName);
    }

    public class SpawnerParameter<T> : SpawnerParameter
    {
        [SerializeField]
        private BoundValue<T> boundValue;

        [UsedImplicitly]
        public BoundValue<T> BoundValue => this.boundValue;

        public override Type ParameterType => typeof(T);

        public override string GetName(string propertyName)
        {
            return propertyName == nameof(this.BoundValue) ? this.parameterName : null;
        }
    }
}