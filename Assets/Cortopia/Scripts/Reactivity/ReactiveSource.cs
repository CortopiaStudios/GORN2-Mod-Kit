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

namespace Cortopia.Scripts.Reactivity
{
    [Serializable]
    public class ReactiveSource<T> : IWritableBindableReactive<T>
    {
        [SerializeField]
        private ReactiveSourceTrigger reactiveTrigger;

        public ReactiveSource(in T value)
        {
            this.reactiveTrigger = new ReactiveSourceTrigger(value);
        }

        public T Value
        {
            get => this.reactiveTrigger.Value;
            set => ((IWritableBindableReactive<T>) this).SetValue(value);
        }

        public Reactive<T> Reactive => new(this.reactiveTrigger);

        bool IBindableReactive.IsReadOnly => false;

        bool IBindableReactive<T>.TrySetValue(in T value)
        {
            ((IWritableBindableReactive<T>) this).SetValue(value);
            return true;
        }

        void IWritableBindableReactive<T>.SetValue(in T value)
        {
            this.reactiveTrigger.OnValueChanging();
            this.reactiveTrigger.Value = value;
            ReactiveTransaction.Register(this.reactiveTrigger);
        }

        [Serializable]
        private sealed class ReactiveSourceTrigger : ReactiveTrigger, IReactiveSource<T>, IReactiveHandler
#if UNITY_EDITOR
            , IEditorPlayModeStateChanged
#endif
        {
            [SerializeField]
            private T value;
            [SerializeField]
            private bool breakOnChange;

            private ReactiveSourceTrigger()
            {
#if UNITY_EDITOR
                this._prevValue = this.value;

                LightweightEditorApplication.AddListener(this);
#endif
            }

            public ReactiveSourceTrigger(in T value)
            {
                this.value = value;
#if UNITY_EDITOR
                this._prevValue = value;
                LightweightEditorApplication.AddListener(this);
#endif
            }

            public T Value
            {
                get => this.value;
                set => this.value = value;
            }

#if UNITY_EDITOR
            private T _orgValue;
            private T _prevValue;
            private bool _orgValueSet;

            public new void OnValueChanging()
            {
                if (EditorApplication.isPlaying)
                {
                    if (!this._orgValueSet)
                    {
                        this._orgValue = this.value;
                        this._orgValueSet = true;
                    }

                    this._prevValue = this.value;
                }

                base.OnValueChanging();
            }

            public new void OnValueChanged()
            {
                if (EditorApplication.isPlaying && this.breakOnChange && !EqualityComparer<T>.Default.Equals(this.value, this._prevValue))
                {
                    DebugBreak.OnChange();
                }

                base.OnValueChanged();
            }

            public void EditorOnPlayModeStateChanged(PlayModeStateChange state)
            {
                switch (state)
                {
                    case PlayModeStateChange.EnteredEditMode:
                        if (this._orgValueSet)
                        {
                            this.value = this._orgValue;
                        }

                        this._orgValueSet = false;
                        break;
                    case PlayModeStateChange.EnteredPlayMode:
                        this._orgValue = this.value;
                        this._orgValueSet = true;
                        break;
                }
            }
#endif
        }
    }
}