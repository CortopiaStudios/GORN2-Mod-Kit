// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

namespace Cortopia.Scripts.Interaction
{
    /// <summary>
    ///     This is a variant of the XR Socket Interactor found in the XR Interaction Toolkit. The original only supports one
    ///     interactor selecting the selected object at a time, while this script supports any amount.
    /// </summary>
    [DisallowMultipleComponent]
    [AddComponentMenu("XR/Custom Socket Interactor", 12)]
    public class CustomSocketInteractor : XRSocketInteractor
    {
    }
}