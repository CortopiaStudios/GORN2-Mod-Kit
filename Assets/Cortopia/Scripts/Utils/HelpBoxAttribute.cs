// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    public enum HelpBoxMessageType
    {
        None,
        Info,
        Warning,
        Error
    }

    public class HelpBoxAttribute : PropertyAttribute
    {
        public readonly HelpBoxMessageType MessageType;
        public readonly string Text;

        public HelpBoxAttribute(string text, HelpBoxMessageType messageType = HelpBoxMessageType.Info)
        {
            this.Text = text;
            this.MessageType = messageType;
        }
    }
}