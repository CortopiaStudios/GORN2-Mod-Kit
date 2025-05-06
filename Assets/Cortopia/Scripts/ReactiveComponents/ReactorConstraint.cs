// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;
using UnityEngine.Animations;

namespace Cortopia.Scripts.ReactiveComponents
{
    [RequireComponent(typeof(IConstraint))]
    public class ReactorConstraint : MonoBehaviour
    {
        [SerializeField]
        [HelpBox("Constraint has to be an IConstraint")]
        private Behaviour constraint;
        [SerializeField]
        private ReactiveConstraintSource[] sources;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        [Serializable]
        private struct ReactiveConstraintSource
        {
            public BoundValue<Transform> transform;
            public BoundValue<float> weight;
        }
    }
}