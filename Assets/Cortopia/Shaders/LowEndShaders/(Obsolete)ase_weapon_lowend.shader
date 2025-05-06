// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/_LowEnd/(obsolete)ase_weapon_lowend"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_BreakUpNoise("BreakUpNoise", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _ISMETALLIC_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform sampler2D _BreakUpNoise;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode80 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 color1_g8 = IsGammaSpace() ? float4(0.6226415,0.1795018,0.1204165,0) : float4(0.3456162,0.02707354,0.01348848,0);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode81 = tex2D( _MaskTexture, uv_MaskTexture );
			float4 color2_g8 = IsGammaSpace() ? float4(0.5188679,0.06118724,0.07892682,0) : float4(0.2319225,0.005018505,0.007057911,0);
			float2 uv_TexCoord85 = i.uv_texcoord * float2( 10,10 );
			float temp_output_83_0 = ( tex2DNode81.r + ( tex2DNode81.r * tex2D( _BreakUpNoise, uv_TexCoord85 ).r ) );
			float4 lerpResult72 = lerp( tex2DNode80 , ( ( color1_g8 * tex2DNode81.r ) + ( color2_g8 * tex2DNode81.a ) ) , step( 0.8 , temp_output_83_0 ));
			float4 temp_output_10_0_g9 = lerpResult72;
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
			float4 temp_output_17_0_g9 = float4( 0,0,0,0 );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g9 = temp_output_10_0_g9;
			#else
				float4 staticSwitch5_g9 = temp_output_17_0_g9;
			#endif
			float clampResult78 = clamp( tex2DNode81.a , 0.1 , 0.85 );
			float lerpResult76 = lerp( tex2DNode80.a , clampResult78 , step( 0.95 , temp_output_83_0 ));
			float temp_output_11_0_g9 = saturate( lerpResult76 );
			float4 temp_cast_4 = (temp_output_11_0_g9).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g9 = temp_cast_4;
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
				float staticSwitch3_g7 = i.vertexColor.r;
			#else
				float staticSwitch3_g7 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g9 = 0.0;
			#else
				float staticSwitch8_g9 = staticSwitch3_g7;
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
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;16.9542,-57.66952;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/_LowEnd/(obsolete)ase_weapon_lowend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.StepOpNode;56;-1319.481,202.117;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-377.2226,-295.5205;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;72;-886.7972,-256.6861;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1571.116,-204.7833;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1517.997,-87.36256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1266.915,-186.3125;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;76;-848.4441,5.226038;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;77;-653.2953,6.489524;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;78;-1368.363,55.78114;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.85;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;79;-824.1641,143.6778;Inherit;False;ase_function_metallic;4;;7;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-1378.355,-444.7643;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;-2311.114,38.85799;Inherit;True;Property;_MaskTexture;MaskTexture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1873.607,327.0985;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-1642.606,303.0985;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;-2229.504,324.7626;Inherit;True;Property;_BreakUpNoise;BreakUpNoise;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-2464.619,348.3236;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-1571.748,544.6257;Inherit;False;Constant;_BloodNoise1;BloodNoise;6;0;Create;True;0;0;0;False;0;False;0.95;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;87;-1318.946,417.4264;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;88;-2175.511,-85.44579;Inherit;False;ase_function_bloodcolor;-1;;8;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.FunctionNode;90;-355.5447,-42.81684;Inherit;False;ase_function_DifSmooth;-1;;9;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.RangedFloatNode;60;-1547.514,184.9851;Inherit;False;Constant;_BloodNoise;BloodNoise;6;0;Create;True;0;0;0;False;0;False;0.8;0.35;0;0;0;1;FLOAT;0
WireConnection;0;0;90;0
WireConnection;0;1;71;0
WireConnection;0;2;90;14
WireConnection;0;3;90;15
WireConnection;0;4;90;16
WireConnection;56;0;60;0
WireConnection;56;1;83;0
WireConnection;72;0;80;0
WireConnection;72;1;75;0
WireConnection;72;2;56;0
WireConnection;73;0;88;0
WireConnection;73;1;81;1
WireConnection;74;0;88;3
WireConnection;74;1;81;4
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;76;0;80;4
WireConnection;76;1;78;0
WireConnection;76;2;87;0
WireConnection;77;0;76;0
WireConnection;78;0;81;4
WireConnection;82;0;81;1
WireConnection;82;1;84;1
WireConnection;83;0;81;1
WireConnection;83;1;82;0
WireConnection;84;1;85;0
WireConnection;87;0;86;0
WireConnection;87;1;83;0
WireConnection;90;10;72;0
WireConnection;90;11;77;0
WireConnection;90;13;79;0
ASEEND*/
//CHKSM=F962173D3C49E542EDD5C5B092A72B0CAF5A9B58