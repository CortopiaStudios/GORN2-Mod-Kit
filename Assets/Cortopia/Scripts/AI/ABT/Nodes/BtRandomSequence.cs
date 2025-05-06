// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtRandomSequence : BtRandomGroup
    {
        public BtRandomSequence(string name, int seed) : base(name, true, seed)
        {
        }

        public BtRandomSequence(string name) : base(name, true)
        {
        }
    }
}