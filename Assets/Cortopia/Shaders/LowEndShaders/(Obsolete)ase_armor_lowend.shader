// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/_LowEnd/(obsolete)ase_armor_lowend"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		_Blood_RCracks_A("Blood_R Cracks_A", 2D) = "white" {}
		_BloodNoiseTiling("BloodNoiseTiling", Vector) = (5,5,0,0)
		_CracksTiling("Cracks Tiling", Vector) = (5,5,0,0)
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
		#pragma surface surf Standard keepalpha exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform sampler2D _Blood_RCracks_A;
		uniform float2 _BloodNoiseTiling;
		uniform float2 _CracksTiling;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode118 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 Diffuse124 = tex2DNode118;
			float4 color1_g11 = IsGammaSpace() ? float4(0.6226415,0.1795018,0.1204165,0) : float4(0.3456162,0.02707354,0.01348848,0);
			float4 color2_g11 = IsGammaSpace() ? float4(0.5188679,0.06118724,0.07892682,0) : float4(0.2319225,0.005018505,0.007057911,0);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode119 = tex2D( _MaskTexture, uv_MaskTexture );
			float BloodWet120 = tex2DNode119.a;
			float BloodDry121 = tex2DNode119.r;
			float2 uv_TexCoord166 = i.uv_texcoord * _BloodNoiseTiling;
			float BloodEdgeMask122 = tex2D( _Blood_RCracks_A, uv_TexCoord166 ).r;
			float BloodLerp159 = saturate( step( 0.8 , ( BloodDry121 + ( BloodDry121 * BloodEdgeMask122 ) ) ) );
			float4 lerpResult112 = lerp( Diffuse124 , ( ( color1_g11 + ( color2_g11 * BloodWet120 ) ) * float4( 0.490566,0.490566,0.490566,0 ) ) , BloodLerp159);
			float2 uv_TexCoord165 = i.uv_texcoord * _CracksTiling;
			float Cracks_Texture163 = tex2D( _Blood_RCracks_A, uv_TexCoord165 ).a;
			float Cracks132 = tex2DNode119.b;
			float Cracks_Lerp134 = step( 0.1 , ( Cracks132 + ( Cracks132 * Cracks_Texture163 ) ) );
			float4 lerpResult113 = lerp( lerpResult112 , ( Cracks_Texture163 * lerpResult112 ) , ( i.vertexColor.g * Cracks_Lerp134 ));
			float4 temp_output_10_0_g12 = lerpResult113;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g12 = temp_cast_1;
			#else
				float4 staticSwitch2_g12 = temp_output_10_0_g12;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g12 = temp_cast_2;
			#else
				float4 staticSwitch1_g12 = staticSwitch2_g12;
			#endif
			o.Albedo = staticSwitch1_g12.xyz;
			float4 temp_output_17_0_g12 = float4( 0,0,0,0 );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g12 = temp_output_10_0_g12;
			#else
				float4 staticSwitch5_g12 = temp_output_17_0_g12;
			#endif
			float Smoothness123 = tex2DNode118.a;
			float lerpResult144 = lerp( Smoothness123 , ( BloodWet120 * 0.7 ) , BloodLerp159);
			float Green_Vertex_Color127 = i.vertexColor.g;
			float lerpResult143 = lerp( lerpResult144 , ( lerpResult144 * ( Cracks_Texture163 * Green_Vertex_Color127 ) ) , Cracks132);
			float temp_output_11_0_g12 = saturate( lerpResult143 );
			float4 temp_cast_4 = (temp_output_11_0_g12).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g12 = temp_cast_4;
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
				float staticSwitch3_g13 = i.vertexColor.r;
			#else
				float staticSwitch3_g13 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g12 = 0.0;
			#else
				float staticSwitch8_g12 = saturate( ( staticSwitch3_g13 * ( 1.0 - BloodLerp159 ) ) );
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
Node;AmplifyShaderEditor.CommentaryNode;93;-1692.138,-486.4945;Inherit;False;311;304;Blood;1;112;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;94;-1365.8,-592.1265;Inherit;False;839.363;412.6;Cracks;7;133;129;128;127;126;125;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;95;-3658.149,-727.7684;Inherit;False;1150.118;450.8744;BloodMask;8;164;159;104;103;102;100;99;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-3656.09,-253.6036;Inherit;False;1148.204;446.0433;Cracks Mask;6;134;131;130;117;116;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3433.459,-499.8596;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-3197.489,-581.5529;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;100;-2744.244,-606.7534;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-1951.808,-555.6785;Inherit;False;124;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-3644.679,-583.5267;Inherit;False;121;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;104;-2951.879,-606.6378;Inherit;True;2;0;FLOAT;0.91;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-1989.029,-383.5177;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-2148.771,-314.2199;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;108;-2404.267,-382.0451;Inherit;False;ase_function_bloodcolor;-1;;11;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.LerpOp;112;-1642.138,-408.3991;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;113;-760.7828,-410.5186;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;114;-2862.808,-204.9977;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-3107.011,-159.7822;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-3365.399,-97.77283;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;118;-4292.443,-635.6052;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;-4296.26,-296.7061;Inherit;True;Property;_MaskTexture;MaskTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-1100.978,-350.6886;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-914.9952,-301.0536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;128;-1123.527,-539.9834;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1342.05,-450.9901;Inherit;False;163;Cracks Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-3616.161,-202.1506;Inherit;False;132;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-3636.914,-87.48579;Inherit;False;163;Cracks Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;135;-658.1497,-154.1265;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;143;-832.5129,-151.3107;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;144;-1232.896,-149.823;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-1046.087,18.55219;Inherit;False;132;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-1590.372,-122.5628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-1231.863,-18.17312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-1570.349,84.6212;Inherit;False;127;Green Vertex Color;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-1536.319,10.67728;Inherit;False;163;Cracks Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1031.895,-85.39432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;153;-519.6735,-74.74393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-700.5746,111.3567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;156;-906.9006,196.6329;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-1450.32,-60.51031;Inherit;False;159;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-1118.656,196.3034;Inherit;False;159;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;169;-4292.631,-29.1097;Inherit;True;Property;_Blood_RCracks_A;Blood_R Cracks_A;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-3937.929,-635.5593;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-3940.913,-539.2091;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-1453.789,-149.7133;Inherit;False;123;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3954.649,-358.7965;Inherit;False;BloodDry;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-3954.795,-254.9088;Inherit;False;Cracks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-3930.671,-137.5467;Inherit;False;BloodWet;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-2385.462,-268.7464;Inherit;False;120;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-1787.67,-122.0155;Inherit;False;120;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-3941.702,-5.676907;Inherit;False;BloodEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-3650.017,-474.7733;Inherit;False;122;BloodEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;165;-4533.863,201.917;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;168;-4766.29,225.5003;Inherit;False;Property;_CracksTiling;Cracks Tiling;6;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;166;-4531.921,-4.998782;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;167;-4808.394,17.92343;Inherit;False;Property;_BloodNoiseTiling;BloodNoiseTiling;5;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-2711.248,-465.2362;Inherit;False;BloodLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-2723.85,-205.7897;Inherit;False;Cracks Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-853.2422,-494.5587;Inherit;False;Green Vertex Color;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-3948.429,274.2273;Inherit;False;Cracks Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;162;-4285.27,178.3495;Inherit;True;Property;_Blood_RCracks_A1;Blood_R Cracks_A;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;169;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;164;-3183.14,-667.0582;Inherit;False;Constant;_BloodNoise;BloodNoise;7;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-2119.602,-204.2749;Inherit;False;159;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-1863.55,-383.8524;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.490566,0.490566,0.490566,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;97;-335.6373,-410.9657;Inherit;False;ase_function_DifSmooth;-1;;12;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;10.7,-411.0998;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/_LowEnd/(obsolete)ase_armor_lowend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1127,-251.8291;Inherit;False;134;Cracks Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;155;-992.9296,112.5185;Inherit;False;ase_function_metallic;2;;13;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
WireConnection;98;0;102;0
WireConnection;98;1;103;0
WireConnection;99;0;102;0
WireConnection;99;1;98;0
WireConnection;100;0;104;0
WireConnection;104;0;164;0
WireConnection;104;1;99;0
WireConnection;106;0;108;0
WireConnection;106;1;107;0
WireConnection;107;0;108;3
WireConnection;107;1;109;0
WireConnection;112;0;101;0
WireConnection;112;1;171;0
WireConnection;112;2;111;0
WireConnection;113;0;112;0
WireConnection;113;1;125;0
WireConnection;113;2;126;0
WireConnection;114;1;116;0
WireConnection;116;0;130;0
WireConnection;116;1;117;0
WireConnection;117;0;130;0
WireConnection;117;1;131;0
WireConnection;125;0;129;0
WireConnection;125;1;112;0
WireConnection;126;0;128;2
WireConnection;126;1;133;0
WireConnection;135;0;143;0
WireConnection;143;0;144;0
WireConnection;143;1;152;0
WireConnection;143;2;145;0
WireConnection;144;0;146;0
WireConnection;144;1;147;0
WireConnection;144;2;157;0
WireConnection;147;0;148;0
WireConnection;149;0;151;0
WireConnection;149;1;150;0
WireConnection;152;0;144;0
WireConnection;152;1;149;0
WireConnection;153;0;154;0
WireConnection;154;0;155;0
WireConnection;154;1;156;0
WireConnection;156;0;158;0
WireConnection;169;1;166;0
WireConnection;124;0;118;0
WireConnection;123;0;118;4
WireConnection;121;0;119;1
WireConnection;132;0;119;3
WireConnection;120;0;119;4
WireConnection;122;0;169;1
WireConnection;165;0;168;0
WireConnection;166;0;167;0
WireConnection;159;0;100;0
WireConnection;134;0;114;0
WireConnection;127;0;128;2
WireConnection;163;0;162;4
WireConnection;162;1;165;0
WireConnection;171;0;106;0
WireConnection;97;10;113;0
WireConnection;97;11;135;0
WireConnection;97;13;153;0
WireConnection;0;0;97;0
WireConnection;0;2;97;14
WireConnection;0;3;97;15
WireConnection;0;4;97;16
ASEEND*/
//CHKSM=8410EB45B676FD69D39F4201C68D12D25826ED85