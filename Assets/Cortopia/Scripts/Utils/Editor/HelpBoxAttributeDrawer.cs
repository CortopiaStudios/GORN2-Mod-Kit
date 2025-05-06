// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Utils.Editor
{
    [CustomPropertyDrawer(typeof(HelpBoxAttribute))]
    public class HelpBoxAttributeDrawer : DecoratorDrawer
    {
        public override float GetHeight()
        {
            try
            {
                var helpBoxAttribute = this.attribute as HelpBoxAttribute;
                if (helpBoxAttribute == null)
                {
                    return base.GetHeight();
                }

                GUIStyle helpBoxStyle = GUI.skin != null ? GUI.skin.GetStyle("helpbox") : null;
                if (helpBoxStyle == null)
                {
                    return base.GetHeight();
                }

                return Mathf.Max(40f, helpBoxStyle.CalcHeight(new GUIContent(helpBoxAttribute.Text), EditorGUIUtility.currentViewWidth) + 4);
            }
            catch (ArgumentException)
            {
                return 3 * EditorGUIUtility.singleLineHeight; // Handle Unity 2022.2 bug by returning default value.
            }
        }

        public override void OnGUI(Rect position)
        {
            var helpBoxAttribute = this.attribute as HelpBoxAttribute;
            if (helpBoxAttribute == null)
            {
                return;
            }

            EditorGUI.HelpBox(position, helpBoxAttribute.Text, this.GetMessageType(helpBoxAttribute.MessageType));
        }

        private MessageType GetMessageType(HelpBoxMessageType helpBoxMessageType)
        {
            switch (helpBoxMessageType)
            {
                default:
                case HelpBoxMessageType.None:
                    return MessageType.None;
                case HelpBoxMessageType.Info:
                    return MessageType.Info;
                case HelpBoxMessageType.Warning:
                    return MessageType.Warning;
                case HelpBoxMessageType.Error:
                    return MessageType.Error;
            }
        }
    }
}