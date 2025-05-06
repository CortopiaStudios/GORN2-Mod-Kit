// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Reactivity;
using UnityEngine;

namespace Cortopia.Scripts.Animation
{
    public class MirrorTransforms : MonoBehaviour
    {
        [SerializeField]
        private UpdateMode updateMode;
        [Space]
        [SerializeField]
        private Space boneMappingSpace;
        [SerializeField]
        private bool syncRoots;
        [SerializeField]
        private BoundValue<Transform> proxyRoot;
        [SerializeField]
        private AutoSetupMode proxyAutoSetupMode;
        [SerializeField]
        private List<Transform> proxyBones;
        [SerializeField]
        private BoundValue<Transform> slaveRoot;
        [SerializeField]
        private AutoSetupMode slaveAutoSetupMode;
        [SerializeField]
        private List<Transform> slaveBones;

        [SerializeField]
        // [CanBeNull]
        [HideInInspector]
        private Transform proxyRootInternal;
        [SerializeField]
        // [CanBeNull]
        [HideInInspector]
        private Transform slaveRootInternal;

        private void Update()
        {
            throw new NotImplementedException();
        }

        private void FixedUpdate()
        {
            throw new NotImplementedException();
        }

        private void LateUpdate()
        {
            throw new NotImplementedException();
        }

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

        [ContextMenu(nameof(DebugLogMappings))]
        public void DebugLogMappings()
        {
            int count = Mathf.Min(this.proxyBones.Count, this.slaveBones.Count);
            for (int i = 0; i < count; i++)
            {
                Transform proxy = this.proxyBones[i];
                Transform slave = this.slaveBones[i];
                string proxyName = proxy ? proxy.name : "NULL";
                string slaveName = slave ? slave.name : "NULL";
                string warning = proxyName != slaveName ? " (!)" : string.Empty;
                Debug.Log($"{proxyName} -> {slaveName}{warning}");
            }
        }

        public void Sync()
        {
            throw new NotImplementedException();
        }

        private enum Space
        {
            Local,
            World
        }

        private enum AutoSetupMode
        {
            None,
            Find,
            MapByNames,
            MapBySkinnedMeshRenderers
        }

        private enum UpdateMode
        {
            Update,
            LateUpdate,
            FixedUpdate
        }
    }
}