// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity.Utils;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Cortopia.Scripts.Reactivity
{
    public interface IWritableBoundValue
    {
        /// <summary>
        ///     True if this may change from external changes
        /// </summary>
        bool IsBound { get; }

        void ResetToDefaultValue();
        void SetCurrentValueAsDefault();
    }

    [Serializable]
    public class WritableBoundValue<T> : IWritableBindableReactive<T>, IWritableBoundValue
#if UNITY_EDITOR
        , IEditorPlayModeStateChanged
#endif
    {
        [SerializeField]
        private Object reference;

        [SerializeField]
        private string propertyName;

        [SerializeField]
        private T defaultValue;
        [SerializeField]
        private bool breakOnChange;

        [NonSerialized]
        private IWritableBindableReactive<T> _bindableReactive;
        [NonSerialized]
        private Reactive<T> _reactive;

        public WritableBoundValue()
        {
        }

        public WritableBoundValue(T defaultValue)
        {
            this.defaultValue = defaultValue;
        }

        public string PropertyName => this.propertyName;

        public Object Reference => this.reference;

        public string ReferenceName => this.IsBound ? this.reference.name : "Not Bound";

        /// <summary>
        ///     True if bound but not to a ReactiveSource
        /// </summary>
        public bool IsReadOnly => false;

        public Reactive<T> Reactive
        {
            get
            {
                this.LazyInit();
                return this._reactive;
            }
        }

        public void SetValue(in T value)
        {
            this.LazyInit();
            this._bindableReactive.SetValue(value);
        }

        /// <summary>
        ///     Will set the value unless it IsReadOnly
        /// </summary>
        /// <returns>Will always return true since WritableBoundValue is guaranteed to be writable.</returns>
        public bool TrySetValue(in T value)
        {
            this.LazyInit();
            this._bindableReactive.SetValue(value);
            return true;
        }

        /// <summary>
        ///     True if this may change from external changes
        /// </summary>
        public bool IsBound => this.reference != null;

        public void ResetToDefaultValue()
        {
            this.SetValue(this.defaultValue);
        }

        public void SetCurrentValueAsDefault()
        {
            this.defaultValue = this.Reactive.Value;
        }

        private void LazyInit()
        {
            if (this._bindableReactive != null)
            {
                return;
            }

#if UNITY_EDITOR
            if (!EditorApplication.isPlaying)
            {
                LightweightEditorApplication.AddListener(this);
            }
            else if (!this._orgValueSet)
            {
                this._orgValue = this.defaultValue;
                this._orgValueSet = true;
            }
#endif

            if (this.IsBound)
            {
                if (this.reference.GetType().GetProperty(this.propertyName) is { } propertyInfo)
                {
                    object value = propertyInfo.GetValue(this.reference);
                    if (value is IWritableBindableReactive<T> reactive)
                    {
                        this._bindableReactive = reactive;
                    }
                    else
                    {
                        this._bindableReactive = new WritableNonReactiveBinding<T>((T) value,
                            (Action<T>) propertyInfo.GetSetMethod().CreateDelegate(typeof(Action<T>), this.reference));
                    }
                }
                // ReSharper disable once SuspiciousTypeConversion.Global
                else if (this.reference is IWritableBindableReactive<T> bindable && string.IsNullOrEmpty(this.propertyName))
                {
                    this._bindableReactive = bindable;
                }
            }
            else
            {
                this._bindableReactive = new ReactiveSource<T>(this.defaultValue);
            }

            if (this._bindableReactive == null)
            {
                throw new UnityException($"Could not initialize BoundValue with reference {this.reference}. I might be caused by bad serialized data.");
            }

            this._reactive = this._bindableReactive.Reactive;

#if UNITY_EDITOR
            this._prevValue = this._reactive.Value;
            this._debugSubscription.Dispose();
            this._debugSubscription = this._reactive.OnValue(x =>
            {
                if (EditorApplication.isPlaying)
                {
                    if (this.breakOnChange && !EqualityComparer<T>.Default.Equals(x, this._prevValue))
                    {
                        DebugBreak.OnChange();
                    }

                    this._prevValue = x;
                }
            });
#endif
        }

#if UNITY_EDITOR
        private ReactiveSubscription _debugSubscription;

        private T _orgValue;
        private T _prevValue;
        private bool _orgValueSet;

        public T EditorDefaultValue => this.defaultValue;

        public void EditorOnPlayModeStateChanged(PlayModeStateChange obj)
        {
            switch (obj)
            {
                case PlayModeStateChange.EnteredEditMode:
                    if (this._orgValueSet)
                    {
                        this.defaultValue = this._orgValue;
                    }

                    this._orgValueSet = false;

                    break;
                case PlayModeStateChange.ExitingEditMode:
                    this._orgValue = this.defaultValue;
                    this._orgValueSet = true;
                    break;
            }
        }
#endif
    }
}