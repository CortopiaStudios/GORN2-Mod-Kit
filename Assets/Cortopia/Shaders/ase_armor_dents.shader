// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_armor_dents"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_DentsNormal("Dents Normal", 2D) = "bump" {}
		_Blood_RDents_G("Blood_R Dents_G", 2D) = "white" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_ISSIMPLESHADER_ON)] _IsSimpleShader("IsSimpleShader", Float) = 0
		_BloodNoiseTiling("BloodNoiseTiling", Vector) = (5,5,0,0)
		_DentsNormalTilingStandardShader("Dents Normal Tiling (Standard Shader)", Vector) = (3,3,0,0)
		_CrackDamage("CrackDamage", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ISSIMPLESHADER_ON
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _ISMETALLIC_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred nolightmap  nodynlightmap nodirlightmap nofog noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _DentsNormal;
		uniform float2 _DentsNormalTilingStandardShader;
		uniform float _CrackDamage;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform sampler2D _Blood_RDents_G;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform float2 _BloodNoiseTiling;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 uv_TexCoord271 = i.uv_texcoord * _DentsNormalTilingStandardShader;
			float3 Dents_Normal158 = UnpackNormal( tex2D( _DentsNormal, uv_TexCoord271 ) );
			float DentAmount266 = ( 1.0 - _CrackDamage );
			float3 lerpResult181 = lerp( Dents_Normal158 , float3(0,0,1) , saturate( DentAmount266 ));
			#ifdef _ISSIMPLESHADER_ON
				float3 staticSwitch223 = lerpResult181;
			#else
				float3 staticSwitch223 = BlendNormals( UnpackNormal( tex2D( _Normal, uv_Normal ) ) , lerpResult181 );
			#endif
			o.Normal = staticSwitch223;
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 Diffuse164 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float Dents_Cracks_Albedo162 = tex2D( _Blood_RDents_G, uv_TexCoord271 ).a;
			float CracksAmount312 = _CrackDamage;
			float4 lerpResult308 = lerp( Diffuse164 , ( Diffuse164 * Dents_Cracks_Albedo162 ) , CracksAmount312);
			float4 color1_g11 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
			float4 color2_g11 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode155 = tex2D( _MaskTexture, uv_MaskTexture );
			float BloodWet159 = tex2DNode155.a;
			float BloodDry160 = tex2DNode155.r;
			float2 uv_TexCoord198 = i.uv_texcoord * _BloodNoiseTiling;
			float BloodEdgeMask161 = tex2D( _Blood_RDents_G, uv_TexCoord198 ).r;
			float BloodLerp188 = saturate( step( 0.8 , ( BloodDry160 + ( BloodDry160 * BloodEdgeMask161 ) ) ) );
			float4 lerpResult144 = lerp( lerpResult308 , ( color1_g11 + ( color2_g11 * BloodWet159 ) ) , BloodLerp188);
			float4 temp_output_10_0_g10 = lerpResult144;
			float4 temp_cast_1 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g10 = temp_cast_1;
			#else
				float4 staticSwitch2_g10 = temp_output_10_0_g10;
			#endif
			float4 temp_cast_2 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g10 = temp_cast_2;
			#else
				float4 staticSwitch1_g10 = staticSwitch2_g10;
			#endif
			o.Albedo = staticSwitch1_g10.xyz;
			float4 temp_output_17_0_g10 = float4( 0,0,0,0 );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g10 = temp_output_10_0_g10;
			#else
				float4 staticSwitch5_g10 = temp_output_17_0_g10;
			#endif
			float Smoothness_CrackDiff318 = lerpResult308.a;
			float lerpResult275 = lerp( Smoothness_CrackDiff318 , ( ( BloodWet159 * 0.6 ) + ( BloodDry160 * 0.3 ) ) , BloodLerp188);
			float temp_output_11_0_g10 = saturate( lerpResult275 );
			float4 temp_cast_4 = (temp_output_11_0_g10).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g10 = temp_cast_4;
			#else
				float4 staticSwitch6_g10 = temp_output_17_0_g10;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g10 = staticSwitch6_g10;
			#else
				float4 staticSwitch3_g10 = staticSwitch5_g10;
			#endif
			o.Emission = staticSwitch3_g10.xyz;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g12 = i.vertexColor.r;
			#else
				float staticSwitch3_g12 = 0.0;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch8_g10 = 0.0;
			#else
				float staticSwitch8_g10 = saturate( ( ( staticSwitch3_g12 * 0.95 ) * ( 1.0 - BloodLerp188 ) ) );
			#endif
			o.Metallic = staticSwitch8_g10;
			#ifdef _SmoothnessView
				float staticSwitch4_g10 = 0.0;
			#else
				float staticSwitch4_g10 = temp_output_11_0_g10;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g10 = 0.0;
			#else
				float staticSwitch7_g10 = staticSwitch4_g10;
			#endif
			o.Smoothness = staticSwitch7_g10;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;125;-635.3914,-795.4527;Inherit;False;311;304;Blood;1;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;126;-2206.949,-1280.733;Inherit;False;553.363;205.9001;Metallic Vertex Color;2;177;176;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;127;-2793.789,-1031.15;Inherit;False;1150.118;450.8744;BloodMask;8;188;136;135;134;133;131;130;129;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;128;-2794.827,-549.9853;Inherit;False;1149.301;458.1115;Dents Mask (Simple);4;201;243;266;312;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-2569.099,-803.2413;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-2333.129,-884.9346;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;135;-2087.519,-910.0195;Inherit;True;2;0;FLOAT;0.91;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-3073.569,-938.9409;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-2318.78,-970.4399;Inherit;False;Constant;_BloodNoise;BloodNoise;7;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;131;-1879.884,-910.1351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;155;-3427.373,-680.4207;Inherit;True;Property;_MaskTexture;MaskTexture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;198;-3668.909,-307.0322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;199;-3945.381,-284.11;Inherit;False;Property;_BloodNoiseTiling;BloodNoiseTiling;8;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;153;-3432.807,-938.2009;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;177;-2137.225,-1241.751;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;271;-3694.868,111.5303;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-3075.821,86.81461;Inherit;False;Dents Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-2780.319,-886.9083;Inherit;False;160;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;197;-3420.909,-125.0322;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;192;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;192;-3428.27,-332.4914;Inherit;True;Property;_Blood_RDents_G;Blood_R Dents_G;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;134;-2785.657,-778.155;Inherit;False;161;BloodEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;272;-4022.296,136.1136;Inherit;False;Property;_DentsNormalTilingStandardShader;Dents Normal Tiling (Standard Shader);9;0;Create;True;0;0;0;False;0;False;3,3;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;156;-3422.448,86.26961;Inherit;True;Property;_DentsNormal;Dents Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-3090.342,-309.0586;Inherit;False;BloodEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-3090.311,-583.9284;Inherit;False;BloodWet;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-3089.289,-657.1783;Inherit;False;BloodDry;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-2731.289,-489.0681;Inherit;False;Property;_CrackDamage;CrackDamage;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;-2289.151,-490.059;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-1921.517,-1194.027;Inherit;False;Green Vertex Color;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;71;-180.6547,-716.6212;Inherit;False;ase_function_DifSmooth;-1;;10;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;315.1624,-730.871;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_armor_dents;False;False;False;False;False;False;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.StaticSwitch;223;-87.99273,-973.0007;Inherit;False;Property;_IsSimpleShader;IsSimpleShader;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;188;-1846.888,-768.6179;Inherit;False;BloodLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;-932.283,-692.4759;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1092.026,-623.1781;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;144;-585.3912,-717.3572;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;140;-1353.342,-693.9135;Inherit;False;ase_function_bloodcolor;-1;;11;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.GetLocalVarNode;141;-1328.717,-577.7045;Inherit;False;159;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-817.5587,-582.9656;Inherit;False;188;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;308;-894.6839,-928.8922;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;148;-1277.89,-1494.592;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;268;-1165.708,-1224.451;Inherit;False;Constant;_Vector1;Vector 1;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;273;-934.7128,-1097.591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-1190.842,-1296.714;Inherit;False;158;Dents Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;147;-388.7703,-1194.4;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;181;-742.5311,-1179.974;Inherit;False;3;0;FLOAT3;1,1,1;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;-1155.219,-1069.504;Inherit;False;266;DentAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-1187.447,-899.616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-1417.021,-1038.049;Inherit;False;164;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-1480.204,-874.5223;Inherit;False;162;Dents Cracks Albedo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1153.03,-775.953;Inherit;False;312;CracksAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;-2351.959,-406.5162;Inherit;False;CracksAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-2057.05,-490.2393;Inherit;False;DentAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-3098.266,-29.3971;Inherit;False;Dents Cracks Albedo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;317;-711.1425,-1010.495;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;-571.668,-937.8723;Inherit;False;Smoothness_CrackDiff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;195;-932.4766,-7.424393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-1144.233,-7.753891;Inherit;False;188;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-707.0048,-162.9021;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;265;-886.3748,-398.4738;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-1364.665,-466.8558;Inherit;False;159;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;263;-1363.184,-359.1536;Inherit;False;160;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;70;-1170.505,-162.5389;Inherit;False;ase_function_metallic;5;;12;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-898.7871,-161.9587;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;319;-803.668,-471.8723;Inherit;False;318;Smoothness_CrackDiff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-741.963,-292.4786;Inherit;False;188;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;275;-546.6812,-468.1769;Inherit;False;3;0;FLOAT;0.5;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;193;-427.1038,-258.0025;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;321;-405.9919,-467.1853;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-1121.265,-466.5236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-1119.184,-361.1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
WireConnection;129;0;133;0
WireConnection;129;1;134;0
WireConnection;130;0;133;0
WireConnection;130;1;129;0
WireConnection;135;0;136;0
WireConnection;135;1;130;0
WireConnection;164;0;153;0
WireConnection;131;0;135;0
WireConnection;198;0;199;0
WireConnection;271;0;272;0
WireConnection;158;0;156;0
WireConnection;197;1;271;0
WireConnection;192;1;198;0
WireConnection;156;1;271;0
WireConnection;161;0;192;1
WireConnection;159;0;155;4
WireConnection;160;0;155;1
WireConnection;243;0;201;0
WireConnection;176;0;177;2
WireConnection;71;10;144;0
WireConnection;71;11;321;0
WireConnection;71;13;193;0
WireConnection;0;0;71;0
WireConnection;0;1;223;0
WireConnection;0;2;71;14
WireConnection;0;3;71;15
WireConnection;0;4;71;16
WireConnection;223;1;147;0
WireConnection;223;0;181;0
WireConnection;188;0;131;0
WireConnection;138;0;140;0
WireConnection;138;1;139;0
WireConnection;139;0;140;3
WireConnection;139;1;141;0
WireConnection;144;0;308;0
WireConnection;144;1;138;0
WireConnection;144;2;143;0
WireConnection;308;0;132;0
WireConnection;308;1;309;0
WireConnection;308;2;311;0
WireConnection;273;0;180;0
WireConnection;147;0;148;0
WireConnection;147;1;181;0
WireConnection;181;0;179;0
WireConnection;181;1;268;0
WireConnection;181;2;273;0
WireConnection;309;0;132;0
WireConnection;309;1;310;0
WireConnection;312;0;201;0
WireConnection;266;0;243;0
WireConnection;162;0;197;4
WireConnection;317;0;308;0
WireConnection;318;0;317;3
WireConnection;195;0;196;0
WireConnection;194;0;320;0
WireConnection;194;1;195;0
WireConnection;265;0;171;0
WireConnection;265;1;264;0
WireConnection;320;0;70;0
WireConnection;275;0;319;0
WireConnection;275;1;265;0
WireConnection;275;2;172;0
WireConnection;193;0;194;0
WireConnection;321;0;275;0
WireConnection;171;0;187;0
WireConnection;264;0;263;0
ASEEND*/
//CHKSM=3E2BB24FD89C50F0D95E2AE69871F77279DC0BA3