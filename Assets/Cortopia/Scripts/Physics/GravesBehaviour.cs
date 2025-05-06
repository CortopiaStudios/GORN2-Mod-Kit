// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEngine;

namespace Cortopia.Scripts.Physics
{
    public abstract class GravesBehaviour : MonoBehaviour
    {
        public virtual int ExecutionOrder => 0;

        protected virtual void OnEnable()
        {
            throw new NotImplementedException();
        }

        protected virtual void OnDisable()
        {
            throw new NotImplementedException();
        }

        public abstract void GravesFixedUpdate();
    }
}