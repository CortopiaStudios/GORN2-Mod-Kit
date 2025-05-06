using System;

namespace Cortopia.Scripts.AI.Navigation
{
    /// <summary>
    /// Struct to help define a NavMeshAgent-type. Uses a PropertyDrawer to imitate how Unity displays NavMeshAgent-types.
    /// </summary>
    [Serializable]
    public struct NavMeshAgentType
    {
        public int id;
    }
}