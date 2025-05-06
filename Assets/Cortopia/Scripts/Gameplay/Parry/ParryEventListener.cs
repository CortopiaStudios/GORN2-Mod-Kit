// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Utils;
using UnityEngine;
using UnityEngine.Events;

namespace Cortopia.Scripts.Gameplay.Parry
{
    public struct ParryEvent
    {
        public bool WasParried;
        public bool IsParrying;
        public ParryType Type;
        public Collision Collision;
    }

    public enum ParryType
    {
        Block,
        Parry
    }

    public class ParryEventListener : MonoBehaviour
    {
        public UnityEvent<ParryEvent> onParry = new();

        [HelpBox("Listen to parry events from child objects and jointed objects.")]
        [Space]
        [SerializeField]
        private UnityEvent<Pose> onDidBlock;
        [SerializeField]
        private UnityEvent<Pose> onDidParry;
        [SerializeField]
        private UnityEvent<Pose> onWasBlocked;
        [SerializeField]
        private UnityEvent<Pose> onWasParried;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }
    }
}