using UnityEngine;

namespace Cortopia.Scripts.Gore.Slicing.Internal
{
    public class BoneHierarchyModifier : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("If an object has this set to true, all its children will be copied during slicing")]
        private bool copyHierarchyWhenSlicing = true;

        public bool CopyHierarchyWhenSlicing => this.copyHierarchyWhenSlicing;
    }
}
