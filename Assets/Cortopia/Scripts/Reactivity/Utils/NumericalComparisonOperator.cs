// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Utils
{
    public enum NumericalComparisonOperator
    {
        EqualTo,
        NotEqualTo,
        GreaterThan,
        EqualsOrGreaterThan,
        LessThan,
        EqualsOrLessThan
    }

    public static class NumericalComparisonExtensions
    {
        public static bool CompareTo(this int value, int otherValue, NumericalComparisonOperator comparisonOperator)
        {
            return comparisonOperator switch
            {
                NumericalComparisonOperator.EqualTo => value == otherValue,
                NumericalComparisonOperator.NotEqualTo => value != otherValue,
                NumericalComparisonOperator.GreaterThan => value > otherValue,
                NumericalComparisonOperator.EqualsOrGreaterThan => value >= otherValue,
                NumericalComparisonOperator.LessThan => value < otherValue,
                NumericalComparisonOperator.EqualsOrLessThan => value <= otherValue,
                _ => throw new ArgumentOutOfRangeException()
            };
        }

        public static bool CompareTo(this float value, float otherValue, NumericalComparisonOperator comparisonOperator)
        {
            return comparisonOperator switch
            {
                NumericalComparisonOperator.EqualTo => Mathf.Approximately(value, otherValue),
                NumericalComparisonOperator.NotEqualTo => !Mathf.Approximately(value, otherValue),
                NumericalComparisonOperator.GreaterThan => value > otherValue,
                NumericalComparisonOperator.EqualsOrGreaterThan => value >= otherValue,
                NumericalComparisonOperator.LessThan => value < otherValue,
                NumericalComparisonOperator.EqualsOrLessThan => value <= otherValue,
                _ => throw new ArgumentOutOfRangeException()
            };
        }
    }
}