// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Specular_Probes
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(ReflectionProbe))]
    public class SpecularProbeRenderer : MonoBehaviour
    {
#if UNITY_EDITOR
        [Tooltip("Will only draw specular highlights for lights in this radius")]
        public float radius = 100;

        private ReflectionProbe _probe;

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = new Color(1, 1, 1, 0.25f);
            Gizmos.DrawWireSphere(this.transform.position, this.radius);
        }

        private void Start()
        {
            if (Application.isPlaying)
            {
                Destroy(this);
            }
        }

#if UNITY_2019_2_OR_NEWER
        // Unity added bakeCompleted action in 2019.2
        private void OnEnable()
        {
            Lightmapping.bakeCompleted += this.OnBakeCompleted;
        }

        private void OnDisable()
        {
            Lightmapping.bakeCompleted -= this.OnBakeCompleted;
        }

        private void OnBakeCompleted()
        {
            Debug.Log("Baking Specular Highlights");
            this.Render();
        }
#endif

        [ContextMenu("Render")]
        public void Render()
        {
            this._probe = this.GetComponent<ReflectionProbe>();

            var allLights = FindObjectsOfType<SpecularProbeLight>();
            var closeLights = new List<SpecularProbeLight>();

            for (var i = 0; i < allLights.Length; i++)
            {
                //find lights within radius of probe
                if ((allLights[i].transform.position - this.transform.position).sqrMagnitude < this.radius * this.radius)
                {
                    closeLights.Add(allLights[i]);
                    // create specular highlight sphere
                    allLights[i].Draw();
                }
            }

            //render probe
            var path = AssetDatabase.GetAssetPath(this._probe.bakedTexture);
            Lightmapping.BakeReflectionProbe(this._probe, path);

            // remove all created lights, cleaning up scene
            for (var i = 0; i < closeLights.Count; i++)
            {
                closeLights[i].Hide();
            }
        }

        [ContextMenu("Render All")]
        public void RenderAll()
        {
            foreach (var r in FindObjectsOfType<SpecularProbeRenderer>())
            {
                r.Render();
            }
        }

#endif
    }
}