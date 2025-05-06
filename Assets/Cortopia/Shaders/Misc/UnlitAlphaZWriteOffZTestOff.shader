Shader "Cortopia/Misc/Unlit Alpha ZWrite Off ZTest Off" {
    Properties {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform float4 _Color;
            struct VertexInput {
                float4 vertex : POSITION;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;

                UNITY_VERTEX_OUTPUT_STEREO
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float3 emissive = _Color.rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,_Color.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}