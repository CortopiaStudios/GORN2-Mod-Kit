// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using JetBrains.Annotations;

namespace Cortopia.Scripts.Reactivity.Reactors
{
    public class ReactorIntSelectReactiveTrigger : ReactorIntSelectObject<ReactiveTriggerCollider>
    {
        [UsedImplicitly]
        public Reactive<bool> IsColliderPresent => new();

        protected override void OnSelectedStateChange(ReactiveTriggerCollider obj, bool isSelected)
        {
        }
    }
}