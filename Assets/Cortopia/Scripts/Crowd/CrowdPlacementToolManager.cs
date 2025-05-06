// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using Cortopia.Scripts.Utils;
using JetBrains.Annotations;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
#endif

namespace Cortopia.Scripts.Crowd
{
    public class CrowdPlacementToolManager : MonoBehaviour
    {
        [SerializeField]
        private GameObject prefabRoot;
        [SerializeField]
        private GameObject crowdPrefab;
        [SerializeField]
        [CanBeNull]
        private Transform arenaCenter;
        [SerializeField]
        private LookDirection lookDirection;

        private void Start()
        {
            throw new NotImplementedException();
        }

#if UNITY_EDITOR

        [InspectorButton("Clear", InspectorButtonAttribute.Context.EditMode)]
        private void Clear()
        {
            var crowdPlacer = this.prefabRoot.GetComponentInChildren<CrowdPlacement>();
            if (!crowdPlacer)
            {
                Debug.LogWarning(this.gameObject + ": The prefab needs to contain a CrowdPlacement component!");
                return;
            }

            List<CrowdPlacementTweaking> crowdPlaceHolders = new();
            var crowdInstances = this.GetAllCrowdPlacementToolInstances(crowdPlacer);
            foreach (CrowdPlacementToolInstance instance in crowdInstances)
            {
                crowdPlaceHolders.AddRange(instance.GetComponentsInChildren<CrowdPlacementTweaking>());
            }

            foreach (CrowdPlacementTweaking placeHolder in crowdPlaceHolders)
            {
                placeHolder.gameObject.SetActive(false);
            }
        }

        private CrowdPlacementToolInstance[] GetAllCrowdPlacementToolInstances(CrowdPlacement crowdPlacer)
        {
            List<CrowdPlacementToolInstance> crowdInstances = new();

            if (PrefabUtility.GetPrefabInstanceStatus(this.prefabRoot) == PrefabInstanceStatus.Connected)
            {
                var addedObjects = PrefabUtility.GetAddedGameObjects(this.prefabRoot);
                foreach (AddedGameObject addedObject in addedObjects)
                {
                    GameObject addedGameObject = addedObject.instanceGameObject;
                    if (addedGameObject && !addedGameObject.GetComponentInParent<CrowdPlacement>())
                    {
                        continue;
                    }

                    if (addedGameObject)
                    {
                        crowdInstances.AddRange(addedGameObject.GetComponentsInChildren<CrowdPlacementToolInstance>());
                    }
                }
            }

            var otherObjects = crowdPlacer.GetComponentsInChildren<CrowdPlacementToolInstance>();
            if (crowdInstances.Count > 0)
            {
                foreach (CrowdPlacementToolInstance otherObject in otherObjects)
                {
                    foreach (CrowdPlacementToolInstance crowdInstance in crowdInstances)
                    {
                        // ReSharper disable once EqualExpressionComparison
                        if (crowdInstance.GetInstanceID() != crowdInstance.GetInstanceID())
                        {
                            crowdInstances.Add(otherObject);
                        }
                    }
                }
            }
            else
            {
                crowdInstances.AddRange(otherObjects);
            }

            return crowdInstances.ToArray();
        }

#endif
    }

    public enum LookDirection
    {
        Forward,
        ArenaCenter
    }
}