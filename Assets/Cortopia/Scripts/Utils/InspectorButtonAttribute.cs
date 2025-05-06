// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    [AttributeUsage(AttributeTargets.Method)]
    public class InspectorButtonAttribute : Attribute
    {
        public enum Context
        {
            PlayMode,
            EditMode,
            Both
        }

        private readonly Context _availability;

        public InspectorButtonAttribute(string buttonName, Context availability)
        {
            this.ButtonName = buttonName;
            this._availability = availability;
        }

        public string ButtonName { get; private set; }

        public bool CanBePressed =>
            this._availability == Context.Both || (Application.isPlaying && this._availability == Context.PlayMode) ||
            (!Application.isPlaying && this._availability == Context.EditMode);
    }
}