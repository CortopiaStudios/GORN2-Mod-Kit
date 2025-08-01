// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_hub_floor"
{
	Properties
	{
		[Toggle(_NORMALMAPENABLED_ON)] _NormalmapEnabled("Normalmap Enabled", Float) = 1
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_HEIGHTFOG_ON)] _HeightFog("HeightFog", Float) = 1
		_TEX_ArmoryGutsGrass_Dif("TEX_ArmoryGutsGrass_Dif", 2D) = "white" {}
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_GrassTiling("GrassTiling", Float) = 0
		_TEX_Sand_02_Dif("TEX_Sand_02_Dif", 2D) = "white" {}
		_TEX_SandPrints_01("TEX_SandPrints_01", 2D) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _NORMALMAPENABLED_ON
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _HEIGHTFOG_ON
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma shader_feature_local _ISMETALLIC_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred nodynlightmap nofog noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv3_texcoord3;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _TEX_Sand_02_Dif;
		uniform sampler2D _TEX_ArmoryGutsGrass_Dif;
		uniform float _GrassTiling;
		uniform sampler2D _TEX_SandPrints_01;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			#ifdef _NORMALMAPENABLED_ON
				float3 staticSwitch35 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			#else
				float3 staticSwitch35 = float3(0,0,1);
			#endif
			o.Normal = staticSwitch35;
			float4 tex2DNode63 = tex2D( _TEX_Sand_02_Dif, i.uv_texcoord );
			float2 temp_cast_0 = (_GrassTiling).xx;
			float2 uv_TexCoord120 = i.uv_texcoord * temp_cast_0;
			float4 tex2DNode122 = tex2D( _TEX_ArmoryGutsGrass_Dif, uv_TexCoord120 );
			float4 lerpResult116 = lerp( tex2DNode63 , tex2DNode122 , i.vertexColor);
			float4 tex2DNode64 = tex2D( _TEX_SandPrints_01, i.uv3_texcoord3 );
			float4 lerpResult67 = lerp( lerpResult116 , tex2DNode64 , tex2DNode64.a);
			float4 temp_output_10_0_g12 = lerpResult67;
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g12 = temp_cast_2;
			#else
				float4 staticSwitch2_g12 = temp_output_10_0_g12;
			#endif
			float4 temp_cast_3 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g12 = temp_cast_3;
			#else
				float4 staticSwitch1_g12 = staticSwitch2_g12;
			#endif
			o.Albedo = staticSwitch1_g12.xyz;
			float4 temp_cast_5 = (0.0).xxxx;
			float3 ase_worldPos = i.worldPos;
			#ifdef _FLIPFOG_ON
				float staticSwitch22_g14 = ( 1.0 - ase_worldPos.y );
			#else
				float staticSwitch22_g14 = ase_worldPos.y;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch27_g14 = FogStart;
			#else
				float staticSwitch27_g14 = _FogStart;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch25_g14 = FogRange;
			#else
				float staticSwitch25_g14 = _FogRange;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float4 staticSwitch23_g14 = FogColor;
			#else
				float4 staticSwitch23_g14 = _FogColor;
			#endif
			#ifdef _HEIGHTFOG_ON
				float4 staticSwitch15 = ( float4( 0,0,0,0 ) + ( saturate( ( (0.0 + (( staticSwitch22_g14 - staticSwitch27_g14 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g14 ) ) * staticSwitch23_g14 ) );
			#else
				float4 staticSwitch15 = temp_cast_5;
			#endif
			float4 temp_output_17_0_g12 = staticSwitch15;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g12 = temp_output_10_0_g12;
			#else
				float4 staticSwitch5_g12 = temp_output_17_0_g12;
			#endif
			float lerpResult124 = lerp( tex2DNode63.a , tex2DNode122.a , i.vertexColor.r);
			float temp_output_11_0_g12 = lerpResult124;
			float4 temp_cast_8 = (temp_output_11_0_g12).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g12 = temp_cast_8;
			#else
				float4 staticSwitch6_g12 = temp_output_17_0_g12;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g12 = staticSwitch6_g12;
			#else
				float4 staticSwitch3_g12 = staticSwitch5_g12;
			#endif
			o.Emission = staticSwitch3_g12.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g15 = i.vertexColor.r;
			#else
				float staticSwitch3_g15 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g12 = 0.0;
			#else
				float staticSwitch8_g12 = staticSwitch3_g15;
			#endif
			o.Metallic = staticSwitch8_g12;
			#ifdef _SmoothnessView
				float staticSwitch4_g12 = 0.0;
			#else
				float staticSwitch4_g12 = temp_output_11_0_g12;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g12 = 0.0;
			#else
				float staticSwitch7_g12 = staticSwitch4_g12;
			#endif
			o.Smoothness = staticSwitch7_g12;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.FunctionNode;31;-396.5,-213.125;Inherit;False;ase_function_DifSmooth;-1;;12;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StaticSwitch;15;-743.5,-111.9147;Inherit;False;Property;_HeightFog;HeightFog;4;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-936.5,-89.91467;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;23;-45.5,-412.9147;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;22;667.5,-401.9147;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;35;449.5,-240.9147;Inherit;False;Property;_NormalmapEnabled;Normalmap Enabled;0;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;40;249.5,-415.9147;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-51.5,-331.125;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;c695cb51ddec2aa479946cb87ef45b01;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;57;-1074.5,-13.9147;Inherit;False;ase_function_heightFog;6;;14;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;11;-844.5,90.875;Inherit;False;ase_function_metallic;2;;15;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;769,-236;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_hub_floor;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;116;-1096.657,-1135.327;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-2500.885,-454.3965;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-1530.045,-364.8827;Inherit;True;Property;_TEX_SandPrints_01;TEX_SandPrints_01;15;0;Create;True;0;0;0;False;0;False;-1;3e0b309da29752b428e6ecaef5bfa434;3e0b309da29752b428e6ecaef5bfa434;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;119;-1569.542,-1043.844;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1970.93,-683.7735;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-1719.31,-725.2214;Inherit;True;Property;_TEX_Sand_02_Dif;TEX_Sand_02_Dif;13;0;Create;True;0;0;0;False;0;False;-1;d03600fac3d720545b869739898aa516;d03600fac3d720545b869739898aa516;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;121;-1911.779,-1088.323;Inherit;True;Property;_TEX_Sand_02_Dif1;TEX_Sand_02_Dif;14;0;Create;True;0;0;0;False;0;False;-1;d03600fac3d720545b869739898aa516;d03600fac3d720545b869739898aa516;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;122;-1843.638,-1317.74;Inherit;True;Property;_TEX_ArmoryGutsGrass_Dif;TEX_ArmoryGutsGrass_Dif;5;0;Create;True;0;0;0;False;0;False;-1;20f5bac38c24ff24490279c565a8d852;20f5bac38c24ff24490279c565a8d852;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;120;-2228.826,-1076.473;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;-2520.731,-1017.543;Inherit;False;Property;_GrassTiling;GrassTiling;12;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-891.9551,-498.8008;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;124;-951.515,-296.2621;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
WireConnection;31;10;67;0
WireConnection;31;11;124;0
WireConnection;31;17;15;0
WireConnection;31;13;11;0
WireConnection;15;1;32;0
WireConnection;15;0;57;0
WireConnection;23;0;31;0
WireConnection;22;0;23;0
WireConnection;35;1;40;0
WireConnection;35;0;4;0
WireConnection;0;0;22;0
WireConnection;0;1;35;0
WireConnection;0;2;31;14
WireConnection;0;3;31;15
WireConnection;0;4;31;16
WireConnection;116;0;63;0
WireConnection;116;1;122;0
WireConnection;116;2;119;0
WireConnection;64;1;66;0
WireConnection;63;1;65;0
WireConnection;121;1;120;0
WireConnection;122;1;120;0
WireConnection;120;0;123;0
WireConnection;67;0;116;0
WireConnection;67;1;64;0
WireConnection;67;2;64;4
WireConnection;124;0;63;4
WireConnection;124;1;122;4
WireConnection;124;2;119;0
ASEEND*/
//CHKSM=EFFF9A2A06F728F8996709FDBE9BA59A100E918E