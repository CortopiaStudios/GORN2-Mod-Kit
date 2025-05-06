// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.BehaviorTree.Spawning;
using Cortopia.Scripts.Reactivity;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    public class ArmorLocationRandomizer : MonoBehaviour
    {
        private static ArmorLocationFlags[] _armorLocationFlagValues;
        [HelpBox("Call the public method Randomize() (using a UnityEvent for example) to update the reactive ArmorLocationFlag Result.")]
        [SerializeField]
        private ArmorLocationFlags alwaysIncludedArmorLocations;
        [SerializeField]
        private ArmorLocationFlags randomizedArmorLocations;

        public Reactive<ArmorLocationFlags> Result => new();

        public void Randomize()
        {
            throw new NotImplementedException();
        }
    }
}