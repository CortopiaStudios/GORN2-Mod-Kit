// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Linq;
using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Operators
{
    public class ReactiveFloatAddMany : MonoBehaviour
    {
        [SerializeField]
        private BoundValue<float>[] values;

        [UsedImplicitly]
        public Reactive<float> Result =>
            // Null check to avoid errors in BoundValueDrawer
            this.values != null
                ? this.values.Select(x => x.Reactive)
                    .Combine()
                    .Select(xs =>
                    {
                        float result = 0f;
                        foreach (float x in xs)
                        {
                            result += x;
                        }

                        return result;
                    })
                : Reactive.Constant<float>(0);
    }
}