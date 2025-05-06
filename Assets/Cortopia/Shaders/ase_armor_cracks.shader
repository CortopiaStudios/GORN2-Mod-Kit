// Upgrade NOTE: upgraded instancing buffer 'Cortopiaase_armor_cracks' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_armor_cracks"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_CracksNormal("Cracks Normal", 2D) = "bump" {}
		_Blood_RCracks_A("Blood_R Cracks_A", 2D) = "white" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_ISSIMPLESHADER_ON)] _IsSimpleShader("IsSimpleShader", Float) = 0
		_BloodNoiseTiling("BloodNoiseTiling", Vector) = (5,5,0,0)
		_CracksTiling("Cracks Tiling", Vector) = (5,5,0,0)
		_CracksNoise("Cracks Noise", Vector) = (1,1,0,0)
		_CrackDamage("CrackDamage", Range( 0 , 1)) = 0
		_Damage("Damage", Float) = 0
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
		#pragma multi_compile_instancing
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
		uniform sampler2D _CracksNormal;
		uniform float2 _CracksTiling;
		uniform sampler2D _MaskTexture;
		uniform sampler2D _Blood_RCracks_A;
		uniform float2 _CracksNoise;
		uniform float _CrackDamage;
		uniform sampler2D _Albedo_Smoothness;
		uniform float2 _BloodNoiseTiling;

		UNITY_INSTANCING_BUFFER_START(Cortopiaase_armor_cracks)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Normal_ST)
#define _Normal_ST_arr Cortopiaase_armor_cracks
			UNITY_DEFINE_INSTANCED_PROP(float4, _MaskTexture_ST)
#define _MaskTexture_ST_arr Cortopiaase_armor_cracks
			UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_Smoothness_ST)
#define _Albedo_Smoothness_ST_arr Cortopiaase_armor_cracks
			UNITY_DEFINE_INSTANCED_PROP(float, _Damage)
#define _Damage_arr Cortopiaase_armor_cracks
		UNITY_INSTANCING_BUFFER_END(Cortopiaase_armor_cracks)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Normal_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Normal_ST_arr, _Normal_ST);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST_Instance.xy + _Normal_ST_Instance.zw;
			float3 tex2DNode148 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_TexCoord154 = i.uv_texcoord * _CracksTiling;
			float3 Cracks_Normal158 = UnpackNormal( tex2D( _CracksNormal, uv_TexCoord154 ) );
			float Green_Vertex_Color176 = i.vertexColor.g;
			float3 lerpResult181 = lerp( tex2DNode148 , Cracks_Normal158 , Green_Vertex_Color176);
			float4 _MaskTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MaskTexture_ST_arr, _MaskTexture_ST);
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST_Instance.xy + _MaskTexture_ST_Instance.zw;
			float4 tex2DNode155 = tex2D( _MaskTexture, uv_MaskTexture );
			float Cracks185 = tex2DNode155.b;
			float2 uv_TexCoord228 = i.uv_texcoord * _CracksNoise;
			float Noise209 = tex2D( _Blood_RCracks_A, uv_TexCoord228 ).g;
			float temp_output_204_0 = ( Noise209 * _CrackDamage );
			float NoiseNoClamp218 = temp_output_204_0;
			float3 lerpResult146 = lerp( tex2DNode148 , BlendNormals( tex2DNode148 , lerpResult181 ) , ( Cracks185 + ( NoiseNoClamp218 * i.vertexColor.g ) ));
			#ifdef _ISSIMPLESHADER_ON
				float3 staticSwitch223 = float3(0,0,1);
			#else
				float3 staticSwitch223 = lerpResult146;
			#endif
			o.Normal = staticSwitch223;
			float4 _Albedo_Smoothness_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_Smoothness_ST_arr, _Albedo_Smoothness_ST);
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST_Instance.xy + _Albedo_Smoothness_ST_Instance.zw;
			float4 tex2DNode153 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 Diffuse164 = tex2DNode153;
			float4 color1_g11 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
			float4 color2_g11 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
			float BloodWet159 = tex2DNode155.a;
			float BloodDry160 = tex2DNode155.r;
			float2 uv_TexCoord198 = i.uv_texcoord * _BloodNoiseTiling;
			float BloodEdgeMask161 = tex2D( _Blood_RCracks_A, uv_TexCoord198 ).r;
			float BloodLerp188 = saturate( step( 0.8 , ( BloodDry160 + ( BloodDry160 * BloodEdgeMask161 ) ) ) );
			float4 lerpResult144 = lerp( Diffuse164 , ( color1_g11 + ( color2_g11 * BloodWet159 ) ) , BloodLerp188);
			float Cracks_Texture162 = tex2D( _Blood_RCracks_A, uv_TexCoord154 ).a;
			float Cracks_Lerp191 = saturate( step( 0.1 , ( ( Cracks185 + ( Cracks185 * Cracks_Texture162 ) ) + temp_output_204_0 ) ) );
			float4 lerpResult145 = lerp( lerpResult144 , ( Cracks_Texture162 * lerpResult144 ) , ( i.vertexColor.g * Cracks_Lerp191 ));
			float4 temp_output_10_0_g10 = lerpResult145;
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
			float4 color230 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float _Damage_Instance = UNITY_ACCESS_INSTANCED_PROP(_Damage_arr, _Damage);
			float4 temp_output_17_0_g10 = saturate( ( color230 * _Damage_Instance ) );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g10 = temp_output_10_0_g10;
			#else
				float4 staticSwitch5_g10 = temp_output_17_0_g10;
			#endif
			float Smoothness163 = tex2DNode153.a;
			float lerpResult167 = lerp( Smoothness163 , ( BloodWet159 * 0.7 ) , BloodLerp188);
			float lerpResult166 = lerp( lerpResult167 , ( lerpResult167 * ( Cracks_Texture162 * Green_Vertex_Color176 ) ) , ( Cracks185 + ( Green_Vertex_Color176 * NoiseNoClamp218 ) ));
			float temp_output_11_0_g10 = saturate( lerpResult166 );
			float4 temp_cast_5 = (temp_output_11_0_g10).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g10 = temp_cast_5;
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
				float staticSwitch8_g10 = saturate( ( staticSwitch3_g12 * ( 1.0 - BloodLerp188 ) ) );
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
Node;AmplifyShaderEditor.CommentaryNode;125;-827.7778,-789.8763;Inherit;False;311;304;Blood;1;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;126;-501.4398,-895.5081;Inherit;False;839.363;412.6;Cracks;7;186;178;177;176;175;174;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;127;-2793.789,-1031.15;Inherit;False;1150.118;450.8744;BloodMask;8;188;136;135;134;133;131;130;129;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;128;-2792.827,-556.9853;Inherit;False;1149.301;458.1115;Cracks Mask;12;201;149;218;210;217;204;152;191;183;208;184;151;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;71;528.723,-714.3475;Inherit;False;ase_function_DifSmooth;-1;;10;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1024.54,-728.5973;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_armor_cracks;False;False;False;False;False;False;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-2569.099,-803.2413;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-2333.129,-884.9346;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-1087.448,-859.0601;Inherit;False;164;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-2780.319,-886.9083;Inherit;False;160;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-2785.657,-778.155;Inherit;False;161;BloodEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;135;-2087.519,-910.0195;Inherit;True;2;0;FLOAT;0.91;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;-1124.669,-686.8995;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1284.411,-617.6017;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;140;-1539.907,-685.4269;Inherit;False;ase_function_bloodcolor;-1;;11;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.GetLocalVarNode;141;-1521.102,-572.1281;Inherit;False;159;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;144;-777.7776,-711.7808;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;145;103.5776,-713.9003;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-3090.289,-662.1783;Inherit;False;BloodDry;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-3077.342,-309.0586;Inherit;False;BloodEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-3073.569,-938.9409;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;188;-1846.888,-768.6179;Inherit;False;BloodLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-2318.78,-970.4399;Inherit;False;Constant;_BloodNoise;BloodNoise;7;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;131;-1879.884,-910.1351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;-2345.504,-482.1695;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;-2784.851,-404.2832;Inherit;False;162;Cracks Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;208;-1897.711,-507.6905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-77.5507,-581.9263;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;93.2522,-794.7268;Inherit;False;Green Vertex Color;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-3076.553,-842.5908;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-236.6182,-654.0704;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;155;-3427.373,-680.4207;Inherit;True;Property;_MaskTexture;MaskTexture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;186;-282.3348,-558.0245;Inherit;False;191;Cracks Lerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-2778.631,-512.2401;Inherit;False;185;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-2560.289,-429.1039;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-2293.714,-254.1726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;217;-2132.703,-482.6412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;148;-730.2275,-1476.983;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;180;-686.832,-1048.379;Inherit;False;176;Green Vertex Color;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;69.33301,-93.74303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;70;-249.1677,-24.37982;Inherit;False;ase_function_metallic;5;;12;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;195;-156.1389,61.73462;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-367.8949,61.40512;Inherit;False;188;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-3090.311,-513.9284;Inherit;False;BloodWet;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-1009.945,-577.3892;Inherit;False;188;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;224;366.5852,-947.5271;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;223;621.3851,-970.727;Inherit;False;Property;_IsSimpleShader;IsSimpleShader;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-486.6901,-744.3719;Inherit;False;162;Cracks Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;177;-272.1672,-855.3651;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;146;309.0844,-1085.295;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;219;137.512,-1011.251;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;147;-205.4534,-1172.952;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;181;-377.752,-1117.495;Inherit;False;3;0;FLOAT3;1,1,1;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-74.776,-1074.124;Inherit;False;185;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-47.81104,-1000.161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-319.9213,-987.3262;Inherit;False;218;NoiseNoClamp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-660.0875,-1134.298;Inherit;False;158;Cracks Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-2766.98,-176.2202;Inherit;False;Property;_CrackDamage;CrackDamage;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;198;-3668.909,-307.0322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;199;-3945.381,-284.11;Inherit;False;Property;_BloodNoiseTiling;BloodNoiseTiling;8;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;192;-3428.27,-332.4914;Inherit;True;Property;_Blood_RCracks_A;Blood_R Cracks_A;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;149;-2005.05,-416.797;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;153;-3431.261,-938.1992;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;142;-1306.33,-815.1193;Inherit;False;164;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-1026.713,-774.9976;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;185;-3087.669,-588.723;Inherit;False;Cracks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-3084.2,262.3417;Inherit;False;Cracks Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-3083.448,156.3728;Inherit;False;Cracks Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;156;-3418.827,263.7967;Inherit;True;Property;_CracksNormal;Cracks Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-3743.339,288.9998;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;157;-3975.766,312.583;Inherit;False;Property;_CracksTiling;Cracks Tiling;9;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;227;-3421.603,-133.4794;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;192;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;197;-3423.288,60.49511;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;192;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-2092.543,-255.4437;Inherit;False;NoiseNoClamp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;-1869.797,-331.7172;Inherit;False;Cracks Lerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;-2738.934,-253.7549;Inherit;False;209;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;228;-3670.827,-111.2676;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;-3105.41,-59.87357;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;229;-3931.254,-88.68445;Inherit;False;Property;_CracksNoise;Cracks Noise;10;0;Create;True;0;0;0;False;0;False;1,1;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;166;-79,-459;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;167;-479,-459;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-703,-459;Inherit;False;163;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-831,-443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-1039,-443;Inherit;False;159;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-479,-331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-783,-299;Inherit;False;162;Cracks Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-271,-395;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-703,-379;Inherit;False;188;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;221;-242.3236,-226.8746;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-415.2596,-225.6281;Inherit;False;185;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-553.811,-177.161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-816.989,-229.7605;Inherit;False;176;Green Vertex Color;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;-791.0333,-154.1208;Inherit;False;218;NoiseNoClamp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;165;130,-458;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;193;233.234,-92.8436;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;234;291.1494,-432.5298;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;160.1494,-347.5298;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;230;-97.4695,-295.2278;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;232;-85.85059,-124.5298;Inherit;False;InstancedProperty;_Damage;Damage;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;71;10;145;0
WireConnection;71;11;165;0
WireConnection;71;17;234;0
WireConnection;71;13;193;0
WireConnection;0;0;71;0
WireConnection;0;1;223;0
WireConnection;0;2;71;14
WireConnection;0;3;71;15
WireConnection;0;4;71;16
WireConnection;129;0;133;0
WireConnection;129;1;134;0
WireConnection;130;0;133;0
WireConnection;130;1;129;0
WireConnection;135;0;136;0
WireConnection;135;1;130;0
WireConnection;138;0;140;0
WireConnection;138;1;139;0
WireConnection;139;0;140;3
WireConnection;139;1;141;0
WireConnection;144;0;132;0
WireConnection;144;1;138;0
WireConnection;144;2;143;0
WireConnection;145;0;144;0
WireConnection;145;1;174;0
WireConnection;145;2;175;0
WireConnection;160;0;155;1
WireConnection;161;0;192;1
WireConnection;164;0;153;0
WireConnection;188;0;131;0
WireConnection;131;0;135;0
WireConnection;151;0;183;0
WireConnection;151;1;152;0
WireConnection;208;0;149;0
WireConnection;175;0;177;2
WireConnection;175;1;186;0
WireConnection;176;0;177;2
WireConnection;163;0;153;4
WireConnection;174;0;178;0
WireConnection;174;1;144;0
WireConnection;152;0;183;0
WireConnection;152;1;184;0
WireConnection;204;0;210;0
WireConnection;204;1;201;0
WireConnection;217;0;151;0
WireConnection;217;1;204;0
WireConnection;194;0;70;0
WireConnection;194;1;195;0
WireConnection;195;0;196;0
WireConnection;159;0;155;4
WireConnection;223;1;146;0
WireConnection;223;0;224;0
WireConnection;146;0;148;0
WireConnection;146;1;147;0
WireConnection;146;2;219;0
WireConnection;219;0;189;0
WireConnection;219;1;226;0
WireConnection;147;0;148;0
WireConnection;147;1;181;0
WireConnection;181;0;148;0
WireConnection;181;1;179;0
WireConnection;181;2;180;0
WireConnection;226;0;220;0
WireConnection;226;1;177;2
WireConnection;198;0;199;0
WireConnection;192;1;198;0
WireConnection;149;1;217;0
WireConnection;137;1;142;0
WireConnection;185;0;155;3
WireConnection;158;0;156;0
WireConnection;162;0;197;4
WireConnection;156;1;154;0
WireConnection;154;0;157;0
WireConnection;227;1;228;0
WireConnection;197;1;154;0
WireConnection;218;0;204;0
WireConnection;191;0;208;0
WireConnection;228;0;229;0
WireConnection;209;0;227;2
WireConnection;166;0;167;0
WireConnection;166;1;168;0
WireConnection;166;2;221;0
WireConnection;167;0;170;0
WireConnection;167;1;171;0
WireConnection;167;2;172;0
WireConnection;171;0;187;0
WireConnection;169;0;182;0
WireConnection;169;1;173;0
WireConnection;168;0;167;0
WireConnection;168;1;169;0
WireConnection;221;0;190;0
WireConnection;221;1;225;0
WireConnection;225;0;173;0
WireConnection;225;1;222;0
WireConnection;165;0;166;0
WireConnection;193;0;194;0
WireConnection;234;0;233;0
WireConnection;233;0;230;0
WireConnection;233;1;232;0
ASEEND*/
//CHKSM=A42DFC02F25AED765B7F8C91B06AF8BFD47FDECD