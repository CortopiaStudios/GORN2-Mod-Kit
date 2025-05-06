// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;

namespace Cortopia.Scripts.GlobalShaderProperties
{
    public class GlobalShaderPropertyInt : GlobalShaderProperty<int>
    {
        protected override void SetGlobalProperty(string propertyName, int value)
        {
            throw new NotImplementedException();
        }
    }
}