// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_env_arena"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
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
			float4 tex2DNode1 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 color1_g7 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode56 = tex2D( _MaskTexture, uv_MaskTexture );
			float4 color2_g7 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
			float2 uv_TexCoord54 = i.uv_texcoord * float2( 5,5 );
			float temp_output_61_0 = ( tex2DNode56.r + ( tex2DNode56.r * tex2D( _BreakUpNoise, uv_TexCoord54 ).r ) );
			float smoothstepResult103 = smoothstep( 0.7 , 0.8 , temp_output_61_0);
			float clampResult153 = clamp( smoothstepResult103 , 0.0 , 0.98 );
			float4 lerpResult57 = lerp( tex2DNode1 , ( ( color1_g7 * tex2DNode56.r ) + ( color2_g7 * tex2DNode56.a ) ) , clampResult153);
			float4 temp_output_10_0_g5 = lerpResult57;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g5 = temp_cast_1;
			#else
				float4 staticSwitch2_g5 = temp_output_10_0_g5;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g5 = temp_cast_2;
			#else
				float4 staticSwitch1_g5 = staticSwitch2_g5;
			#endif
			o.Albedo = staticSwitch1_g5.xyz;
			float4 temp_output_17_0_g5 = float4( 0,0,0,0 );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g5 = temp_output_10_0_g5;
			#else
				float4 staticSwitch5_g5 = temp_output_17_0_g5;
			#endif
			float clampResult92 = clamp( ( tex2DNode56.a * 2.0 ) , 0.2 , 0.85 );
			float lerpResult88 = lerp( tex2DNode1.a , clampResult92 , step( 0.95 , temp_output_61_0 ));
			float temp_output_11_0_g5 = saturate( lerpResult88 );
			float4 temp_cast_4 = (temp_output_11_0_g5).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g5 = temp_cast_4;
			#else
				float4 staticSwitch6_g5 = temp_output_17_0_g5;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g5 = staticSwitch6_g5;
			#else
				float4 staticSwitch3_g5 = staticSwitch5_g5;
			#endif
			o.Emission = staticSwitch3_g5.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g6 = i.vertexColor.r;
			#else
				float staticSwitch3_g6 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g5 = 0.0;
			#else
				float staticSwitch8_g5 = saturate( ( staticSwitch3_g6 * ( 1.0 - smoothstepResult103 ) ) );
			#endif
			o.Metallic = staticSwitch8_g5;
			#ifdef _SmoothnessView
				float staticSwitch4_g5 = 0.0;
			#else
				float staticSwitch4_g5 = temp_output_11_0_g5;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g5 = 0.0;
			#else
				float staticSwitch7_g5 = staticSwitch4_g5;
			#endif
			o.Smoothness = staticSwitch7_g5;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-781.128,117.2232;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-550.128,93.22321;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-1137.025,114.8873;Inherit;True;Property;_BreakUpNoise;BreakUpNoise;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-407.1109,-588.8161;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;56;-1152.128,-299.9958;Inherit;True;Property;_MaskTexture;MaskTexture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;807.0962,-660.6108;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;94;-226.4702,207.5511;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;109;808.4618,-426.8497;Inherit;False;ase_function_DifSmooth;-1;;5;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;475.7988,-155.7675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;112;633.0982,-262.3679;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;110;170.0977,-34.46777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;108;221.1419,-155.5546;Inherit;False;ase_function_metallic;4;;6;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-1595.954,159.8646;Inherit;False;Property;_BloodNoiseTiling;BloodNoiseTiling;6;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;70;593.0873,-402.6967;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;88;202.9213,-403.7851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-479.2701,334.7512;Inherit;False;Constant;_BloodNoise;BloodNoise;6;0;Create;True;0;0;0;False;0;False;0.95;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;345.8118,-696.9508;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-129.9014,-589.464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-407.9745,-484.8912;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-292.9671,-794.1128;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;153;142.0743,-561.5095;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.98;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;156;-1011.505,-469.4787;Inherit;False;ase_function_bloodcolor;-1;;7;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.RangedFloatNode;158;-501.2246,-1.43457;Inherit;False;Property;_max;max;7;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-500.1,-90.28185;Inherit;False;Property;_min;min;8;0;Create;True;0;0;0;False;0;False;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1372.142,138.4484;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;165;1292.176,-435.1385;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_env_arena;False;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-533.111,-205.6696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;92;-211.8563,-205.8779;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.85;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;103;-213.3279,-26.17028;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;0.8;False;1;FLOAT;0
WireConnection;60;0;56;1
WireConnection;60;1;71;1
WireConnection;61;0;56;1
WireConnection;61;1;60;0
WireConnection;71;1;54;0
WireConnection;64;0;156;0
WireConnection;64;1;56;1
WireConnection;94;0;95;0
WireConnection;94;1;61;0
WireConnection;109;10;57;0
WireConnection;109;11;70;0
WireConnection;109;13;112;0
WireConnection;111;0;108;0
WireConnection;111;1;110;0
WireConnection;112;0;111;0
WireConnection;110;0;103;0
WireConnection;70;0;88;0
WireConnection;88;0;1;4
WireConnection;88;1;92;0
WireConnection;88;2;94;0
WireConnection;57;0;1;0
WireConnection;57;1;59;0
WireConnection;57;2;153;0
WireConnection;59;0;64;0
WireConnection;59;1;63;0
WireConnection;63;0;156;3
WireConnection;63;1;56;4
WireConnection;153;0;103;0
WireConnection;165;0;109;0
WireConnection;165;1;42;0
WireConnection;165;2;109;14
WireConnection;165;3;109;15
WireConnection;165;4;109;16
WireConnection;145;0;56;4
WireConnection;92;0;145;0
WireConnection;103;0;61;0
ASEEND*/
//CHKSM=6F0AC07BE89F6AE4B2839BB225A5A443371A3913