// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Core.Spawn
{
    public abstract class SpawnerParameter : MonoBehaviour
    {
        public enum Direction
        {
            InOut,
            In,
            Out
        }

        public string parameterName;
        public Direction direction;
    }

    public class SpawnerParameter<T> : SpawnerParameter
    {
        [SerializeField]
        private BoundValue<T> boundValue;

        public BoundValue<T> BoundValue => this.boundValue;
    }
}