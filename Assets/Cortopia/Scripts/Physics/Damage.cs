// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cortopia.Scripts.Gameplay;

namespace Cortopia.Scripts.Physics
{
    public abstract record Damage(float Value, DamageContext Context)
    {
        public enum DamageType
        {
            None,
            Impact,
            Slash,
            Stab,
            Slice,
            Tear,
            Crush,
            Fire
        }

        public DamageContext Context { get; } = Context;

        public float Value { get; set; } = Value;
    }
}