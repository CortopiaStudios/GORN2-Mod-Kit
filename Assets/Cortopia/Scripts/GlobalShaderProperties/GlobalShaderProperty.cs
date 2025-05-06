// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.GlobalShaderProperties
{
    public abstract class GlobalShaderProperty<T> : MonoBehaviour
    {
        [SerializeField]
        [TextArea]
        // ReSharper disable once NotAccessedField.Local
        private string description;
        [SerializeField]
        private string propertyName;
        [SerializeField]
        private T value;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        public void SetValue(T newValue)
        {
            throw new NotImplementedException();
        }

        protected abstract void SetGlobalProperty(string propertyName, T value);
    }
}