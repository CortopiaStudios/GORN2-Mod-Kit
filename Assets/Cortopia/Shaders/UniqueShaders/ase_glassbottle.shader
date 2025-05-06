// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_glassbottle"
{
	Properties
	{
		_Color0("Color 0", Color) = (0.06127627,0.1211498,0.1603774,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode1 = ( 2.76 + 21.3 * pow( 1.0 - fresnelNdotV1, 2.19 ) );
				UnityGIInput data;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
				data.worldPos = WorldPosition;
				data.worldViewDir = ase_worldViewDir;
				data.probeHDR[0] = unity_SpecCube0_HDR;
				data.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
				data.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif //specdataif0
				#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
				data.boxMax[0] = unity_SpecCube0_BoxMax;
				data.probePosition[0] = unity_SpecCube0_ProbePosition;
				data.boxMax[1] = unity_SpecCube1_BoxMax;
				data.boxMin[1] = unity_SpecCube1_BoxMin;
				data.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif //specdataif1
				Unity_GlossyEnvironmentData g24 = UnityGlossyEnvironmentSetup( 0.85, ase_worldViewDir, ase_worldNormal, float3(0,0,0));
				float3 indirectSpecular24 = UnityGI_IndirectSpecular( data, 3.85, ase_worldNormal, g24 );
				
				
				finalColor = ( float4( ( fresnelNode1 * indirectSpecular24 ) , 0.0 ) * _Color0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.FresnelNode;1;-146,-133.5;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;24;411.2581,62.67218;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;700.2581,-125.3278;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;954.516,-135.1556;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;682,137.5;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.06127627,0.1211498,0.1603774,0;0.06127627,0.1211498,0.1603774,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;26;1168,-131;Float;False;True;-1;2;ASEMaterialInspector;100;5;ase_glassbottle;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-390.484,-85.15559;Inherit;False;Constant;_Bias;Bias;3;0;Create;True;0;0;0;False;0;False;2.76;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-398.484,-12.15561;Inherit;False;Constant;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;21.3;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-400.484,63.84442;Inherit;False;Constant;_Power;Power;5;0;Create;True;0;0;0;False;0;False;2.19;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;150.516,81.84441;Inherit;False;Constant;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0.85;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;161.2581,163.6722;Inherit;False;Constant;_Occlusion;Occlusion;1;0;Create;True;0;0;0;False;0;False;3.85;1;0;0;0;1;FLOAT;0
WireConnection;1;1;6;0
WireConnection;1;2;7;0
WireConnection;1;3;8;0
WireConnection;24;1;23;0
WireConnection;24;2;27;0
WireConnection;25;0;1;0
WireConnection;25;1;24;0
WireConnection;22;0;25;0
WireConnection;22;1;2;0
WireConnection;26;0;22;0
ASEEND*/
//CHKSM=1A955137D5594D16CCAF445DBD6BD73B6CA2ED0B