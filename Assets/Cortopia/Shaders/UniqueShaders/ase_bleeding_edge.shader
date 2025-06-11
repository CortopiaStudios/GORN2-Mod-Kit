// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_bleeding_edge"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_BloodFlow("BloodFlow", Range( 0 , 1)) = 1
		_Normal("Normal", 2D) = "bump" {}
		_BloodMaskR("BloodMask(R)", 2D) = "white" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		_Inline("Inline", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
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
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform sampler2D _BloodMaskR;
		uniform float _BloodFlow;
		uniform int _Inline;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 color125 = IsGammaSpace() ? float4(0.5943396,0,0,0) : float4(0.3119799,0,0,0);
			float mulTime153 = _Time.y * 0.2;
			float2 appendResult154 = (float2(( 0.2 * mulTime153 ) , mulTime153));
			float2 uv_TexCoord130 = i.uv_texcoord * float2( 4,8 ) + appendResult154;
			float mulTime161 = _Time.y * 0.15;
			float2 appendResult159 = (float2(( -0.2 * mulTime161 ) , mulTime161));
			float2 uv_TexCoord163 = i.uv_texcoord * float2( 3,6 ) + appendResult159;
			float4 lerpResult123 = lerp( tex2DNode1 , ( color125 * saturate( ( ( tex2D( _BloodMaskR, uv_TexCoord130 ).r + tex2D( _BloodMaskR, uv_TexCoord163 ).r ) + 0.5 ) ) ) , ( i.vertexColor.b * step( ( ( 1.0 - i.uv_texcoord.y ) - _BloodFlow ) , 0.0 ) ));
			float4 temp_output_10_0_g9 = lerpResult123;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g9 = temp_cast_1;
			#else
				float4 staticSwitch2_g9 = temp_output_10_0_g9;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g9 = temp_cast_2;
			#else
				float4 staticSwitch1_g9 = staticSwitch2_g9;
			#endif
			o.Albedo = staticSwitch1_g9.xyz;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV11_g11 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode11_g11 = ( 0.0 + 2.0 * pow( 1.0 - fresnelNdotV11_g11, 5.0 ) );
			float4 temp_cast_4 = (( _Inline * fresnelNode11_g11 )).xxxx;
			float4 temp_output_17_0_g9 = temp_cast_4;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g9 = temp_output_10_0_g9;
			#else
				float4 staticSwitch5_g9 = temp_output_17_0_g9;
			#endif
			float temp_output_11_0_g9 = tex2DNode1.a;
			float4 temp_cast_5 = (temp_output_11_0_g9).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g9 = temp_cast_5;
			#else
				float4 staticSwitch6_g9 = temp_output_17_0_g9;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g9 = staticSwitch6_g9;
			#else
				float4 staticSwitch3_g9 = staticSwitch5_g9;
			#endif
			o.Emission = staticSwitch3_g9.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g12 = i.vertexColor.r;
			#else
				float staticSwitch3_g12 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g9 = 0.0;
			#else
				float staticSwitch8_g9 = ( staticSwitch3_g12 * 0.95 );
			#endif
			o.Metallic = staticSwitch8_g9;
			#ifdef _SmoothnessView
				float staticSwitch4_g9 = 0.0;
			#else
				float staticSwitch4_g9 = temp_output_11_0_g9;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g9 = 0.0;
			#else
				float staticSwitch7_g9 = staticSwitch4_g9;
			#endif
			o.Smoothness = staticSwitch7_g9;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred nolightmap  nodynlightmap nodirlightmap nofog noforwardadd 

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
Node;AmplifyShaderEditor.FunctionNode;65;-135.2462,149.5436;Inherit;False;ase_function_DifSmooth;-1;;9;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.SamplerNode;44;-518.3013,-272.1273;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;b7d3ed8a1f501d84395d57ae6f80e5da;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;341.9001,135.3461;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_bleeding_edge;False;False;False;False;False;False;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.FunctionNode;114;-572.645,255.9983;Inherit;False;ase_function_forcegrab;6;;11;28a011451f93f55429710d8f45046efa;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;71;-644.1626,383.9876;Inherit;False;ase_function_metallic;4;;12;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-355.624,383.9875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1082.923,-61.9466;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;a70abea4c04708b419e80aaa65e90fed;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;123;-534.1445,-35.55602;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-1029.069,132.9907;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;125;-1418.883,132.4571;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.5943396,0,0,0;0.4339623,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;178;-1242.821,328.2719;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;-1390.821,426.2719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-1532.795,425.7396;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;154;-2429.624,477.9875;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-2597.624,447.9875;Inherit;False;2;2;0;FLOAT;0.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;153;-2807.624,503.9875;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;159;-2440.122,639.7756;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;130;-2209.36,428.7551;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,8;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;128;-1918.047,403.2535;Inherit;True;Property;_BloodMaskR;BloodMask(R);3;0;Create;True;0;0;0;False;0;False;-1;None;5657507ec4511ef43a15e0e101373dad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;162;-1919.137,599.9888;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;128;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-2608.122,609.7756;Inherit;False;2;2;0;FLOAT;-0.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-2210.45,625.4904;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;161;-2818.122,665.7756;Inherit;False;1;0;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;180;-809.918,679.3542;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;181;-973.918,788.3542;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;182;-1122.918,739.3542;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-1362.918,662.3542;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;118;-1021.979,268.7908;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;184;-1426.918,934.3542;Inherit;False;Property;_BloodFlow;BloodFlow;1;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-769.918,248.3542;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;65;10;123;0
WireConnection;65;11;1;4
WireConnection;65;17;114;0
WireConnection;65;13;172;0
WireConnection;0;0;65;0
WireConnection;0;1;44;0
WireConnection;0;2;65;14
WireConnection;0;3;65;15
WireConnection;0;4;65;16
WireConnection;172;0;71;0
WireConnection;123;0;1;0
WireConnection;123;1;169;0
WireConnection;123;2;179;0
WireConnection;169;0;125;0
WireConnection;169;1;178;0
WireConnection;178;0;177;0
WireConnection;177;0;165;0
WireConnection;165;0;128;1
WireConnection;165;1;162;1
WireConnection;154;0;155;0
WireConnection;154;1;153;0
WireConnection;155;1;153;0
WireConnection;159;0;160;0
WireConnection;159;1;161;0
WireConnection;130;1;154;0
WireConnection;128;1;130;0
WireConnection;162;1;163;0
WireConnection;160;1;161;0
WireConnection;163;1;159;0
WireConnection;180;0;181;0
WireConnection;181;0;182;0
WireConnection;181;1;184;0
WireConnection;182;0;183;2
WireConnection;179;0;118;3
WireConnection;179;1;180;0
ASEEND*/
//CHKSM=FD0878BD1D6D3C5F1431CE5BA4140624337F3917