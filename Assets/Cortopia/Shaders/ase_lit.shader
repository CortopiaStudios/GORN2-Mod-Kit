// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_lit"
{
	Properties
	{
		_AlbedoSmoothness("Albedo Smoothness", 2D) = "white" {}
		[Toggle(_NORMALMAPENABLED_ON)] _NormalmapEnabled("Normalmap Enabled", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_FORCEGRABBABLE_ON)] _ForceGrabbable("ForceGrabbable", Float) = 0
		_Inline("Inline", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _NORMALMAPENABLED_ON
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _FORCEGRABBABLE_ON
		#pragma shader_feature_local _ISMETALLIC_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _AlbedoSmoothness;
		uniform float4 _AlbedoSmoothness_ST;
		uniform int _Inline;

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
			float4 temp_output_10_0_g2 = tex2DNode1;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g2 = temp_cast_1;
			#else
				float4 staticSwitch2_g2 = temp_output_10_0_g2;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g2 = temp_cast_2;
			#else
				float4 staticSwitch1_g2 = staticSwitch2_g2;
			#endif
			o.Albedo = staticSwitch1_g2.xyz;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV11_g1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode11_g1 = ( 0.0 + 2.0 * pow( 1.0 - fresnelNdotV11_g1, 5.0 ) );
			#ifdef _FORCEGRABBABLE_ON
				float staticSwitch9 = ( _Inline * fresnelNode11_g1 );
			#else
				float staticSwitch9 = 0.0;
			#endif
			float4 temp_cast_4 = (staticSwitch9).xxxx;
			float4 temp_output_17_0_g2 = temp_cast_4;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g2 = temp_output_10_0_g2;
			#else
				float4 staticSwitch5_g2 = temp_output_17_0_g2;
			#endif
			float temp_output_11_0_g2 = tex2DNode1.a;
			float4 temp_cast_5 = (temp_output_11_0_g2).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g2 = temp_cast_5;
			#else
				float4 staticSwitch6_g2 = temp_output_17_0_g2;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g2 = staticSwitch6_g2;
			#else
				float4 staticSwitch3_g2 = staticSwitch5_g2;
			#endif
			o.Emission = staticSwitch3_g2.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch8 = i.vertexColor.r;
			#else
				float staticSwitch8 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g2 = 0.0;
			#else
				float staticSwitch8_g2 = staticSwitch8;
			#endif
			o.Metallic = staticSwitch8_g2;
			#ifdef _SmoothnessView
				float staticSwitch4_g2 = 0.0;
			#else
				float staticSwitch4_g2 = temp_output_11_0_g2;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g2 = 0.0;
			#else
				float staticSwitch7_g2 = staticSwitch4_g2;
			#endif
			o.Smoothness = staticSwitch7_g2;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred nodynlightmap nofog noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SamplerNode;1;-246,-382.5;Inherit;True;Property;_AlbedoSmoothness;Albedo Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;6;-453.5,35.25;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-425.5,-48.75;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;8;-73.5,49.25;Inherit;False;Property;_IsMetallic;IsMetallic;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;9;-149.5,-191.75;Inherit;False;Property;_ForceGrabbable;ForceGrabbable;4;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-405.5,-250.75;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-499.5,-167.75;Inherit;False;ase_function_forcegrab;5;;1;28a011451f93f55429710d8f45046efa;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;219.5,-378.75;Inherit;False;ase_function_DifSmooth;-1;;2;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;588,-378;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_lit;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.StaticSwitch;3;170.1667,-536.3466;Inherit;False;Property;_NormalmapEnabled;Normalmap Enabled;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;2;-188.8333,-794.3466;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-288.8333,-625.5569;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;8;1;7;0
WireConnection;8;0;6;1
WireConnection;9;1;10;0
WireConnection;9;0;11;0
WireConnection;12;10;1;0
WireConnection;12;11;1;4
WireConnection;12;17;9;0
WireConnection;12;13;8;0
WireConnection;0;0;12;0
WireConnection;0;1;3;0
WireConnection;0;2;12;14
WireConnection;0;3;12;15
WireConnection;0;4;12;16
WireConnection;3;1;2;0
WireConnection;3;0;4;0
ASEEND*/
//CHKSM=7A1C4CAED9FA0005C9BCA3965149EE67B7CBF7A7