// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

namespace Cortopia.Scripts.Effects
{
    public interface IHapticsPlayer
    {
    }

    [RequireComponent(typeof(ActionBasedController))]
    public class HapticsPlayer : MonoBehaviour, IHapticsPlayer
    {
        private void Start()
        {
            throw new NotImplementedException();
        }

        private void Update()
        {
            throw new NotImplementedException();
        }

        public void PlayTick()
        {
            throw new NotImplementedException();
        }
    }
}