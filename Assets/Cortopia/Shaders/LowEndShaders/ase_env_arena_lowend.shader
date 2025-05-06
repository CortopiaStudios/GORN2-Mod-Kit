// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/_LowEnd/ase_env_arena_lowend"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_BreakUpNoise("BreakUpNoise", 2D) = "white" {}
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nodynlightmap nofog 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform sampler2D _BreakUpNoise;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode72 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 color1_g27 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode80 = tex2D( _MaskTexture, uv_MaskTexture );
			float4 color2_g27 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
			float2 uv_TexCoord76 = i.uv_texcoord * float2( 5,5 );
			float temp_output_70_0 = ( tex2DNode80.r + ( tex2DNode80.r * tex2D( _BreakUpNoise, uv_TexCoord76 ).r ) );
			float temp_output_74_0 = step( 0.75 , temp_output_70_0 );
			float clampResult94 = clamp( temp_output_74_0 , 0.0 , 0.98 );
			float4 lerpResult88 = lerp( tex2DNode72 , ( ( color1_g27 * tex2DNode80.r ) + ( color2_g27 * tex2DNode80.a ) ) , clampResult94);
			float4 temp_output_10_0_g7 = lerpResult88;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g7 = temp_cast_1;
			#else
				float4 staticSwitch2_g7 = temp_output_10_0_g7;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g7 = temp_cast_2;
			#else
				float4 staticSwitch1_g7 = staticSwitch2_g7;
			#endif
			o.Albedo = staticSwitch1_g7.xyz;
			float4 temp_output_17_0_g7 = float4( 0,0,0,0 );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g7 = temp_output_10_0_g7;
			#else
				float4 staticSwitch5_g7 = temp_output_17_0_g7;
			#endif
			float clampResult81 = clamp( ( tex2DNode80.a * 2.0 ) , 0.2 , 0.87 );
			float lerpResult85 = lerp( tex2DNode72.a , clampResult81 , step( 0.95 , temp_output_70_0 ));
			float temp_output_11_0_g7 = saturate( lerpResult85 );
			float4 temp_cast_4 = (temp_output_11_0_g7).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g7 = temp_cast_4;
			#else
				float4 staticSwitch6_g7 = temp_output_17_0_g7;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g7 = staticSwitch6_g7;
			#else
				float4 staticSwitch3_g7 = staticSwitch5_g7;
			#endif
			o.Emission = staticSwitch3_g7.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g8 = i.vertexColor.r;
			#else
				float staticSwitch3_g8 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g7 = 0.0;
			#else
				float staticSwitch8_g7 = ( staticSwitch3_g8 * saturate( ( 1.0 - temp_output_74_0 ) ) );
			#endif
			o.Metallic = staticSwitch8_g7;
			#ifdef _SmoothnessView
				float staticSwitch4_g7 = 0.0;
			#else
				float staticSwitch4_g7 = temp_output_11_0_g7;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g7 = 0.0;
			#else
				float staticSwitch7_g7 = staticSwitch4_g7;
			#endif
			o.Smoothness = staticSwitch7_g7;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1374.859,245.6986;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1143.859,221.6988;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-1730.756,243.3628;Inherit;True;Property;_BreakUpNoise;BreakUpNoise;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-890.0727,-656.6401;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1000.842,-460.3407;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;75;-815.002,341.2267;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-1745.859,-171.5204;Inherit;True;Property;_MaskTexture;MaskTexture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-947.7227,-342.9201;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-696.6417,-441.8698;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;88;-311.3236,-451.1441;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;90;161.6746,-281.1722;Inherit;False;ase_function_DifSmooth;-1;;7;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-1965.874,266.9239;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;85;-284.0858,-262.1621;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;87;-306.5455,-141.2782;Inherit;False;ase_function_metallic;3;;8;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-48.61038,-140.8503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;93;-225.0673,13.73602;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-432.0245,113.8886;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;94;-478.5669,-358.264;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.98;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1042.567,-65.26398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;74;-814.4727,115.1059;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1073.001,463.2267;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.95;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1042.505,65.21468;Inherit;False;Constant;_BloodNoise;BloodNoise;5;0;Create;True;0;0;0;False;0;False;0.75;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;114;-1605.236,-341.0033;Inherit;False;ase_function_bloodcolor;-1;;27;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.SaturateNode;86;-94.93698,-260.8986;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;121;500.684,-282.1075;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/_LowEnd/ase_env_arena_lowend;False;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ClampOpNode;81;-825.3843,-65.08672;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.87;False;1;FLOAT;0
WireConnection;69;0;80;1
WireConnection;69;1;71;1
WireConnection;70;0;80;1
WireConnection;70;1;69;0
WireConnection;71;1;76;0
WireConnection;73;0;114;0
WireConnection;73;1;80;1
WireConnection;75;0;77;0
WireConnection;75;1;70;0
WireConnection;82;0;114;3
WireConnection;82;1;80;4
WireConnection;83;0;73;0
WireConnection;83;1;82;0
WireConnection;88;0;72;0
WireConnection;88;1;83;0
WireConnection;88;2;94;0
WireConnection;90;10;88;0
WireConnection;90;11;86;0
WireConnection;90;13;91;0
WireConnection;85;0;72;4
WireConnection;85;1;81;0
WireConnection;85;2;75;0
WireConnection;91;0;87;0
WireConnection;91;1;93;0
WireConnection;93;0;92;0
WireConnection;92;0;74;0
WireConnection;94;0;74;0
WireConnection;95;0;80;4
WireConnection;74;0;78;0
WireConnection;74;1;70;0
WireConnection;86;0;85;0
WireConnection;121;0;90;0
WireConnection;121;2;90;14
WireConnection;121;3;90;15
WireConnection;121;4;90;16
WireConnection;81;0;95;0
ASEEND*/
//CHKSM=529ACEC1866474BCB4BC586DA362BC5C52E55862