// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_weapon"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
		_BreakUpNoise("BreakUpNoise", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		_Inline("Inline", Int) = 0
		_BloodNoiseTiling("BloodNoiseTiling", Float) = 3
		[Toggle(_ISSIMPLESHADER_ON)] _IsSimpleShader("IsSimpleShader", Float) = 0
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
		#pragma shader_feature_local _ISSIMPLESHADER_ON
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform sampler2D _BreakUpNoise;
		uniform float _BloodNoiseTiling;
		uniform int _Inline;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			#ifdef _ISSIMPLESHADER_ON
				float3 staticSwitch104 = float3(0,0,1);
			#else
				float3 staticSwitch104 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			#endif
			o.Normal = staticSwitch104;
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 color1_g11 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode56 = tex2D( _MaskTexture, uv_MaskTexture );
			float4 color2_g11 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
			float2 temp_cast_0 = (_BloodNoiseTiling).xx;
			float2 uv_TexCoord67 = i.uv_texcoord * temp_cast_0;
			float temp_output_51_0 = ( tex2DNode56.r + ( tex2DNode56.r * tex2D( _BreakUpNoise, uv_TexCoord67 ).r ) );
			float smoothstepResult61 = smoothstep( 0.7 , 0.8 , temp_output_51_0);
			float4 lerpResult52 = lerp( tex2DNode1 , ( ( color1_g11 * tex2DNode56.r ) + ( color2_g11 * tex2DNode56.a ) ) , smoothstepResult61);
			float4 temp_output_10_0_g9 = lerpResult52;
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g9 = temp_cast_2;
			#else
				float4 staticSwitch2_g9 = temp_output_10_0_g9;
			#endif
			float4 temp_cast_3 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g9 = temp_cast_3;
			#else
				float4 staticSwitch1_g9 = staticSwitch2_g9;
			#endif
			o.Albedo = staticSwitch1_g9.xyz;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV11_g10 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode11_g10 = ( 0.0 + 2.0 * pow( 1.0 - fresnelNdotV11_g10, 5.0 ) );
			float4 temp_cast_5 = (( _Inline * fresnelNode11_g10 )).xxxx;
			float4 temp_output_17_0_g9 = temp_cast_5;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g9 = temp_output_10_0_g9;
			#else
				float4 staticSwitch5_g9 = temp_output_17_0_g9;
			#endif
			float clampResult63 = clamp( tex2DNode56.a , 0.6 , 0.9 );
			float lerpResult59 = lerp( tex2DNode1.a , clampResult63 , step( 0.95 , temp_output_51_0 ));
			float temp_output_11_0_g9 = saturate( lerpResult59 );
			float4 temp_cast_6 = (temp_output_11_0_g9).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g9 = temp_cast_6;
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
				float staticSwitch3_g8 = i.vertexColor.r;
			#else
				float staticSwitch3_g8 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g9 = 0.0;
			#else
				float staticSwitch8_g9 = saturate( ( ( staticSwitch3_g8 * 0.95 ) * ( 1.0 - smoothstepResult61 ) ) );
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1960.136,697.5168;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1729.136,673.5169;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-901.7994,-60.42569;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1586.119,-8.522845;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1658.278,915.0449;Inherit;False;Constant;_BloodNoise;BloodNoise;6;0;Create;True;0;0;0;False;0;False;0.95;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;-2331.136,280.2975;Inherit;True;Property;_MaskTexture;MaskTexture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1533,108.8978;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1281.918,9.948079;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;-1387.436,646.4234;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;62;-1405.478,787.8447;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1441.95,-183.638;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;bab462bb7f9768a4cad15f2c7151a3f7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-2325.633,699.981;Inherit;True;Property;_BreakUpNoise;BreakUpNoise;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-2560.75,723.5421;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;65;-135.2462,149.5436;Inherit;False;ase_function_DifSmooth;-1;;9;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;255.7969,146.622;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_weapon;False;False;False;False;False;False;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;59;-820.9326,129.1407;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;-625.7841,130.4042;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-518.3013,-272.1273;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;c65294e1e28e9c645b44523f5d1cf333;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;104;-117.8522,36.4054;Inherit;False;Property;_IsSimpleShader;IsSimpleShader;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;105;-418.1519,-57.1945;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;114;-555.9511,215.8053;Inherit;False;ase_function_forcegrab;6;;10;28a011451f93f55429710d8f45046efa;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;117;-2190.513,110.8146;Inherit;False;ase_function_bloodcolor;-1;;11;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1658.314,444.3024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;63;-1376.366,371.0415;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.6;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2813.314,749.3024;Inherit;False;Property;_BloodNoiseTiling;BloodNoiseTiling;8;0;Create;True;0;0;0;False;0;False;3;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;74;-335.0582,295.8105;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-496.0138,373.8858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-756.4867,647.3182;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;71;-966.3025,485.1359;Inherit;False;ase_function_metallic;4;;8;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-669.737,374.0441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.95;False;1;FLOAT;0
WireConnection;50;0;56;1
WireConnection;50;1;66;1
WireConnection;51;0;56;1
WireConnection;51;1;50;0
WireConnection;52;0;1;0
WireConnection;52;1;58;0
WireConnection;52;2;61;0
WireConnection;54;0;117;0
WireConnection;54;1;56;1
WireConnection;57;0;117;3
WireConnection;57;1;56;4
WireConnection;58;0;54;0
WireConnection;58;1;57;0
WireConnection;61;0;51;0
WireConnection;62;0;55;0
WireConnection;62;1;51;0
WireConnection;66;1;67;0
WireConnection;67;0;116;0
WireConnection;65;10;52;0
WireConnection;65;11;60;0
WireConnection;65;17;114;0
WireConnection;65;13;74;0
WireConnection;0;0;65;0
WireConnection;0;1;104;0
WireConnection;0;2;65;14
WireConnection;0;3;65;15
WireConnection;0;4;65;16
WireConnection;59;0;1;4
WireConnection;59;1;63;0
WireConnection;59;2;62;0
WireConnection;60;0;59;0
WireConnection;104;1;44;0
WireConnection;104;0;105;0
WireConnection;63;0;56;4
WireConnection;74;0;72;0
WireConnection;72;0;118;0
WireConnection;72;1;73;0
WireConnection;73;0;61;0
WireConnection;118;0;71;0
ASEEND*/
//CHKSM=36AABF9325AD04EFBDF0E5516F8789AF3777BA4F