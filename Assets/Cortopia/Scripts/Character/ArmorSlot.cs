// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.BehaviorTree.Spawning;
using Cortopia.Scripts.Physics;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Character
{
    [RequireComponent(typeof(Limb), typeof(Rigidbody))]
    public class ArmorSlot : MonoBehaviour
    {
        [SerializeField]
        [HideInInspector]
        private ConfigurableJoint joint;

        [SerializeField]
        private ArmorLocation location;

        public Reactive<ArmorPiece> ArmorPiece => new();

        public Reactive<bool> HasArmorPiece => new();

        /// <summary>
        ///     This method can be used to connect armor that is present in the prefab from start
        /// </summary>
        public void ConnectPart(ArmorPiece armorPiece)
        {
            throw new NotImplementedException();
        }

        public void OnArmorPieceDestroyed()
        {
            throw new NotImplementedException();
        }

        public void OnOwnerWasSliced(Transform newRoot)
        {
            throw new NotImplementedException();
        }

        public void DetachArmor()
        {
            throw new NotImplementedException();
        }
    }
}