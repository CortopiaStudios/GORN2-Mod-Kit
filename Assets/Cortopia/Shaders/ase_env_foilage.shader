// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_env_foilage"
{
	Properties
	{
		_AlbedoSmoothness("Albedo Smoothness", 2D) = "white" {}
		[Toggle(_NORMALMAPENABLED_ON)] _NormalmapEnabled("Normalmap Enabled", Float) = 0
		[Toggle(_HEIGHTFOG_ON)] _HeightFog("HeightFog", Float) = 1
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_MovementNoise("Movement Noise", 2D) = "white" {}
		_MovementStrenght("Movement Strenght", Float) = 0.6
		_MovementGranularity("Movement Granularity", Range( 0 , 20)) = 0.25
		_MovementSpeed("Movement Speed", Range( 0 , 1)) = 0.17
		[Toggle(_KEYWORD0_ON)] _Keyword0("U&V", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _KEYWORD0_ON
		#pragma shader_feature_local _NORMALMAPENABLED_ON
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _HEIGHTFOG_ON
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nodynlightmap nofog noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _MovementNoise;
		uniform float _MovementSpeed;
		uniform float _MovementGranularity;
		uniform float _MovementStrenght;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _AlbedoSmoothness;
		uniform float4 _AlbedoSmoothness_ST;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_MovementSpeed).xx;
			float2 temp_cast_1 = (_MovementGranularity).xx;
			float2 uv_TexCoord9_g32 = v.texcoord.xy * temp_cast_1;
			#ifdef _KEYWORD0_ON
				float staticSwitch18_g32 = uv_TexCoord9_g32.y;
			#else
				float staticSwitch18_g32 = uv_TexCoord9_g32.x;
			#endif
			float2 temp_cast_2 = (staticSwitch18_g32).xx;
			float2 panner7_g32 = ( 1.0 * _Time.y * temp_cast_0 + temp_cast_2);
			v.vertex.xyz += ( tex2Dlod( _MovementNoise, float4( panner7_g32, 0, 0.0) ) * ( v.color * _MovementStrenght ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			#ifdef _NORMALMAPENABLED_ON
				float3 staticSwitch3 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			#else
				float3 staticSwitch3 = float3(0,0,1);
			#endif
			o.Normal = staticSwitch3;
			float2 uv_AlbedoSmoothness = i.uv_texcoord * _AlbedoSmoothness_ST.xy + _AlbedoSmoothness_ST.zw;
			float4 tex2DNode1 = tex2D( _AlbedoSmoothness, uv_AlbedoSmoothness );
			float4 temp_output_10_0_g31 = tex2DNode1;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g31 = temp_cast_1;
			#else
				float4 staticSwitch2_g31 = temp_output_10_0_g31;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g31 = temp_cast_2;
			#else
				float4 staticSwitch1_g31 = staticSwitch2_g31;
			#endif
			o.Albedo = staticSwitch1_g31.xyz;
			float4 temp_cast_4 = (0.0).xxxx;
			float3 ase_worldPos = i.worldPos;
			#ifdef _FLIPFOG_ON
				float staticSwitch22_g12 = ( 1.0 - ase_worldPos.y );
			#else
				float staticSwitch22_g12 = ase_worldPos.y;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch27_g12 = FogStart;
			#else
				float staticSwitch27_g12 = _FogStart;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch25_g12 = FogRange;
			#else
				float staticSwitch25_g12 = _FogRange;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float4 staticSwitch23_g12 = FogColor;
			#else
				float4 staticSwitch23_g12 = _FogColor;
			#endif
			#ifdef _HEIGHTFOG_ON
				float4 staticSwitch23 = ( float4( 0,0,0,0 ) + ( saturate( ( (0.0 + (( staticSwitch22_g12 - staticSwitch27_g12 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g12 ) ) * staticSwitch23_g12 ) );
			#else
				float4 staticSwitch23 = temp_cast_4;
			#endif
			float4 temp_output_17_0_g31 = staticSwitch23;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g31 = temp_output_10_0_g31;
			#else
				float4 staticSwitch5_g31 = temp_output_17_0_g31;
			#endif
			float temp_output_11_0_g31 = tex2DNode1.a;
			float4 temp_cast_6 = (temp_output_11_0_g31).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g31 = temp_cast_6;
			#else
				float4 staticSwitch6_g31 = temp_output_17_0_g31;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g31 = staticSwitch6_g31;
			#else
				float4 staticSwitch3_g31 = staticSwitch5_g31;
			#endif
			o.Emission = staticSwitch3_g31.xyz;
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g31 = 0.0;
			#else
				float staticSwitch8_g31 = 0.0;
			#endif
			o.Metallic = staticSwitch8_g31;
			#ifdef _SmoothnessView
				float staticSwitch4_g31 = 0.0;
			#else
				float staticSwitch4_g31 = temp_output_11_0_g31;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g31 = 0.0;
			#else
				float staticSwitch7_g31 = staticSwitch4_g31;
			#endif
			o.Smoothness = staticSwitch7_g31;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StaticSwitch;23;-40.8434,-202.5012;Inherit;False;Property;_HeightFog;HeightFog;2;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-240.917,-200.0483;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;24;-384.9906,-125.5955;Inherit;False;ase_function_heightFog;4;;12;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;-401,-381.5;Inherit;True;Property;_AlbedoSmoothness;Albedo Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;65b7c51b50ae8a14b960d7eacc69faa5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;45;217.0834,-386.6975;Inherit;False;ase_function_DifSmooth;-1;;31;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StaticSwitch;3;191.1667,-502.3466;Inherit;False;Property;_NormalmapEnabled;Normalmap Enabled;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;2;-199.8333,-779.3466;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;43;-5.916595,-97.04829;Inherit;False;ase_function_foilage_movement_flesh;10;;32;f84ed69fdec9c3b4ba23e41df1bd0c5c;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-297.8333,-619.5569;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;d9cb33316ccdc9f42a95c0e66753e52d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;46;583,-387;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_env_foilage;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;1;25;0
WireConnection;23;0;24;0
WireConnection;45;10;1;0
WireConnection;45;11;1;4
WireConnection;45;17;23;0
WireConnection;3;1;2;0
WireConnection;3;0;4;0
WireConnection;46;0;45;0
WireConnection;46;1;3;0
WireConnection;46;2;45;14
WireConnection;46;3;45;15
WireConnection;46;4;45;16
WireConnection;46;11;43;0
ASEEND*/
//CHKSM=69A25D792A0BB4809958F8AE7BB27F4F7B6B16F5