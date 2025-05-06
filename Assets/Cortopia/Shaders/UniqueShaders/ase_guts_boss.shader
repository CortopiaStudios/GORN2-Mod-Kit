// Upgrade NOTE: upgraded instancing buffer 'ase_guts_boss' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_guts_boss"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "white" {}
		[Toggle(_NORMALMAPENABLED_ON)] _NormalmapEnabled("Normalmap Enabled", Float) = 1
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_HEIGHTFOG_ON)] _HeightFog("HeightFog", Float) = 1
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_DisableEmissive("DisableEmissive", Range( 0 , 1)) = 1
		_Damage("Damage", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature_local _NORMALMAPENABLED_ON
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _HEIGHTFOG_ON
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma shader_feature_local _ISMETALLIC_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Albedo_Smoothness;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;
		uniform float _DisableEmissive;

		UNITY_INSTANCING_BUFFER_START(ase_guts_boss)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Normal_ST)
#define _Normal_ST_arr ase_guts_boss
			UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_Smoothness_ST)
#define _Albedo_Smoothness_ST_arr ase_guts_boss
			UNITY_DEFINE_INSTANCED_PROP(float, _Damage)
#define _Damage_arr ase_guts_boss
		UNITY_INSTANCING_BUFFER_END(ase_guts_boss)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Normal_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Normal_ST_arr, _Normal_ST);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST_Instance.xy + _Normal_ST_Instance.zw;
			#ifdef _NORMALMAPENABLED_ON
				float3 staticSwitch7 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			#else
				float3 staticSwitch7 = float3(0,0,1);
			#endif
			o.Normal = staticSwitch7;
			float4 _Albedo_Smoothness_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_Smoothness_ST_arr, _Albedo_Smoothness_ST);
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST_Instance.xy + _Albedo_Smoothness_ST_Instance.zw;
			float4 tex2DNode2 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 temp_output_10_0_g15 = tex2DNode2;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g15 = temp_cast_1;
			#else
				float4 staticSwitch2_g15 = temp_output_10_0_g15;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g15 = temp_cast_2;
			#else
				float4 staticSwitch1_g15 = staticSwitch2_g15;
			#endif
			o.Albedo = staticSwitch1_g15.xyz;
			float4 temp_cast_4 = (0.0).xxxx;
			float3 ase_worldPos = i.worldPos;
			#ifdef _FLIPFOG_ON
				float staticSwitch22_g16 = ( 1.0 - ase_worldPos.y );
			#else
				float staticSwitch22_g16 = ase_worldPos.y;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch27_g16 = FogStart;
			#else
				float staticSwitch27_g16 = _FogStart;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch25_g16 = FogRange;
			#else
				float staticSwitch25_g16 = _FogRange;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float4 staticSwitch23_g16 = FogColor;
			#else
				float4 staticSwitch23_g16 = _FogColor;
			#endif
			#ifdef _HEIGHTFOG_ON
				float4 staticSwitch3 = ( float4( 0,0,0,0 ) + ( saturate( ( (0.0 + (( staticSwitch22_g16 - staticSwitch27_g16 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g16 ) ) * staticSwitch23_g16 ) );
			#else
				float4 staticSwitch3 = temp_cast_4;
			#endif
			float _Damage_Instance = UNITY_ACCESS_INSTANCED_PROP(_Damage_arr, _Damage);
			float4 color30 = IsGammaSpace() ? float4(0.8113208,0,0,0) : float4(0.6231937,0,0,0);
			float4 color19 = IsGammaSpace() ? float4(0.6901961,1,0,0) : float4(0.4341537,1,0,0);
			float4 lerpResult13 = lerp( ( _Damage_Instance * color30 ) , ( ( tex2DNode2 * color19 ) * (( 5.0 * _DisableEmissive ) + (0.0 - -1.0) * (( 20.0 * _DisableEmissive ) - ( 5.0 * _DisableEmissive )) / (1.0 - -1.0)) ) , i.vertexColor.b);
			float4 temp_output_17_0_g15 = ( staticSwitch3 + saturate( lerpResult13 ) );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g15 = temp_output_10_0_g15;
			#else
				float4 staticSwitch5_g15 = temp_output_17_0_g15;
			#endif
			float temp_output_11_0_g15 = tex2DNode2.a;
			float4 temp_cast_7 = (temp_output_11_0_g15).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g15 = temp_cast_7;
			#else
				float4 staticSwitch6_g15 = temp_output_17_0_g15;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g15 = staticSwitch6_g15;
			#else
				float4 staticSwitch3_g15 = staticSwitch5_g15;
			#endif
			o.Emission = staticSwitch3_g15.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g17 = i.vertexColor.r;
			#else
				float staticSwitch3_g17 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g15 = 0.0;
			#else
				float staticSwitch8_g15 = staticSwitch3_g17;
			#endif
			o.Metallic = staticSwitch8_g15;
			#ifdef _SmoothnessView
				float staticSwitch4_g15 = 0.0;
			#else
				float staticSwitch4_g15 = temp_output_11_0_g15;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g15 = 0.0;
			#else
				float staticSwitch7_g15 = staticSwitch4_g15;
			#endif
			o.Smoothness = staticSwitch7_g15;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StaticSwitch;7;374.9546,-318.3531;Inherit;False;Property;_NormalmapEnabled;Normalmap Enabled;1;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;8;174.9546,-493.3531;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;9;-126.0454,-408.5634;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1022.7,-205.7;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_guts_boss;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.FunctionNode;1;422.0543,-174.8635;Inherit;False;ase_function_DifSmooth;-1;;15;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StaticSwitch;3;-148.0454,-64.7531;Inherit;False;Property;_HeightFog;HeightFog;5;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;2;-1024.545,-215.3384;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;10;110.9546,690.0366;Inherit;False;ase_function_metallic;3;;17;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-316.0454,-65.75307;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-598.045,-39.7531;Inherit;False;ase_function_heightFog;6;;16;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-295.8749,268.1673;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;273.7249,-73.73288;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-523.7753,270.8671;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-807.5751,297.5673;Inherit;False;Constant;_EmissiveColor;EmissiveColor;12;0;Create;True;0;0;0;False;0;False;0.6901961,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;26;-603.5349,502.0116;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;5;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-836.535,574.0116;Inherit;False;2;2;0;FLOAT;5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1207.636,712.0115;Inherit;False;Property;_DisableEmissive;DisableEmissive;12;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-837.535,691.0116;Inherit;False;2;2;0;FLOAT;20;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;-325.1893,401.4862;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;17;108.8248,40.46741;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;13;-64.17499,243.2672;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-251.978,115.8861;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;30;-532.535,104.0116;Inherit;False;Constant;_Color0;Color 0;14;0;Create;True;0;0;0;False;0;False;0.8113208,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-470.978,31.88611;Inherit;False;InstancedProperty;_Damage;Damage;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;7;1;8;0
WireConnection;7;0;9;0
WireConnection;0;0;1;0
WireConnection;0;1;7;0
WireConnection;0;2;1;14
WireConnection;0;3;1;15
WireConnection;0;4;1;16
WireConnection;1;10;2;0
WireConnection;1;11;2;4
WireConnection;1;17;14;0
WireConnection;1;13;10;0
WireConnection;3;1;4;0
WireConnection;3;0;11;0
WireConnection;15;0;18;0
WireConnection;15;1;26;0
WireConnection;14;0;3;0
WireConnection;14;1;17;0
WireConnection;18;0;2;0
WireConnection;18;1;19;0
WireConnection;26;3;29;0
WireConnection;26;4;28;0
WireConnection;29;1;27;0
WireConnection;28;1;27;0
WireConnection;17;0;13;0
WireConnection;13;0;33;0
WireConnection;13;1;15;0
WireConnection;13;2;12;3
WireConnection;33;0;32;0
WireConnection;33;1;30;0
ASEEND*/
//CHKSM=07928D0D07F669497CC4AC55F06702A252AD19B7