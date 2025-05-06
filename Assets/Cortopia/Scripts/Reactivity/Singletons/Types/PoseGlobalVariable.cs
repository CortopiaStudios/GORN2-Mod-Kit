// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;
using UnityEngine;

namespace Cortopia.Scripts.Reactivity.Singletons.Types
{
    [CreateAssetMenu(menuName = "Cortopia/Global Variable/Pose")]
    public sealed class PoseGlobalVariable : GlobalVariable<Pose>
    {
        [UsedImplicitly]
        public Reactive<Vector3> Position => this.Variable.Reactive.Select(pose => pose.position);

        [UsedImplicitly]
        public Reactive<Quaternion> Rotation => this.Variable.Reactive.Select(pose => pose.rotation);
    }
}