// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Utils;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public class ResetJointWhenStretched : GravesBehaviour
    {
        [HelpBox("This component is automatically destroyed if the joint is 'null' or the joints Connected Body is 'null'.")]
        [SerializeField]
        private Joint joint;

        private void Start()
        {
            throw new NotImplementedException();
        }

        public override void GravesFixedUpdate()
        {
            throw new NotImplementedException();
        }
    }
}