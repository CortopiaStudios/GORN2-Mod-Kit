// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEngine;
using UnityEngine.Rendering;

namespace Specular_Probes
{
    [RequireComponent(typeof(Light))]
    public class SpecularProbeLight : MonoBehaviour
    {
#if UNITY_EDITOR
        [Tooltip("The intensity of the Light will be multiplied by this. Recommended to raise for small lights, and lower for large lights")]
        public float intensityMultiplier = 1;
        [Tooltip("Radius of the light sphere geometry")]
        public float radius = 0.25f;

        private const float IntensityConstant = 5;

        private LightRenderer _instance;
        private Light _light;
        private static readonly int BaseColor = Shader.PropertyToID("_BaseColor");

        private void OnDrawGizmosSelected()
        {
            this.Start();
            Gizmos.color = this._light.color;
            Gizmos.DrawWireSphere(this.transform.position, this.radius);
        }

        private class LightRenderer
        {
            public readonly GameObject GameObject;
            public readonly MeshFilter MeshFilter;
            public readonly MeshRenderer Renderer;

            public LightRenderer(GameObject g)
            {
                this.GameObject = g;
                this.MeshFilter = g.AddComponent<MeshFilter>();
                this.Renderer = g.AddComponent<MeshRenderer>();
            }

            public Transform Transform => this.GameObject.transform;

            public void Destroy()
            {
                DestroyImmediate(this.GameObject);
            }
        }

        private void Start()
        {
            if (this._light == null)
            {
                this._light = this.GetComponent<Light>();
            }
        }

        public void Draw()
        {
            this.Start();

            if (this._instance != null)
            {
                this.Hide();
            }

            this._instance = new LightRenderer(new GameObject("lightRenderer"));
            this._instance.Transform.localScale = Vector3.one * this.radius;
            this._instance.Transform.parent = this.transform;
            this._instance.Transform.localPosition = Vector3.zero;
            this._instance.MeshFilter.sharedMesh = ((GameObject) Resources.Load("SpecSphere", typeof(GameObject))).GetComponent<MeshFilter>().sharedMesh;

#if UNITY_2018_1_OR_NEWER
            if (GraphicsSettings.currentRenderPipeline != null)
            {
                // Scriptable Render Pipeline Support
                this._instance.Renderer.sharedMaterial = new Material(GraphicsSettings.currentRenderPipeline.defaultParticleMaterial.shader);
                this._instance.Renderer.sharedMaterial.SetColor(BaseColor, this._light.color * this.CalcBrightness());
            }
            else
#endif
            {
                // Built in Render Pipeline Support
                this._instance.Renderer.sharedMaterial = new Material(Shader.Find($"Particles/Standard Unlit")) {color = this._light.color * this.CalcBrightness()};
            }

            this._instance.GameObject.isStatic = true;
        }

        public void Hide()
        {
            if (this._instance != null)
            {
                if (this._instance.GameObject != null)
                {
                    DestroyImmediate(this._instance.Renderer.sharedMaterial);
                    this._instance.Destroy();
                }
            }

            this._instance = null;
        }

        private float CalcBrightness()
        {
            return this._light.intensity * this.intensityMultiplier * IntensityConstant;
        }
#endif
    }
}