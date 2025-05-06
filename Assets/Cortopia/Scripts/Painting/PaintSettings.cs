// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;

namespace Cortopia.Scripts.Painting
{
    [CreateAssetMenu(menuName = "Cortopia/BloodPainting/Paint Settings Object")]
    public class PaintSettings : ScriptableObject
    {
        [Tooltip("How many particles that can apply paint in one frame. Any particles exceeding this number will be ignored.")]
        [SerializeField]
        private int maxParticlesPaintingPerFrame;

        [Tooltip("How many surfaces will be painted without delay, at most. Non-culled surfaces will be prioritized, but anything above this number will be ignored.")]
        [SerializeField]
        private int maxSurfacesPaintedPerFrame;

        [Tooltip("The seconds it takes for Dry Blood to dry (approximation based on fixed update)")]
        [SerializeField]
        private float secondsDryBlood;

        [Tooltip("The seconds it takes for Clean Blood to clean (approximation based on fixed update)")]
        [SerializeField]
        private float secondsCleanBlood;

        [Tooltip("When a particle hits a collider, its position is compared to the bounds of each connected PaintSurface's renderer bounds. However, the bounds don't " +
                 "necessarily overlap the collider, and so they may need some padding to ensure all surfaces can be painted properly. " +
                 "\n\nBeware that a high value may result in many irrelevant paint jobs being added to the paint queue, filling it up without visual results.")]
        [SerializeField]
        private float particleSurfaceBoundsPadding = 0.5f;
    }
}