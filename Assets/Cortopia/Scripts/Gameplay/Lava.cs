// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Effects;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Gameplay
{
    public class Lava : MonoBehaviour
    {
        [Tooltip("The layers a collider can be part of in order to bounce on lava.")]
        [SerializeField]
        private LayerMask bounceLayers = int.MaxValue;
        [Tooltip("The vector is defined in local space to this object.")]
        [SerializeField]
        private Vector3 bounceDirection = Vector3.up;
        [SerializeField]
        private ForceMode forceMode = ForceMode.Impulse;
        [Space]
        [SerializeField]
        private AirFixedHitFXSpawner effect;
        [SerializeField]
        private BoundValue<float> fxIntensity = new(1);
    }
}