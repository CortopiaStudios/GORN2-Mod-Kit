// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_env_armory"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_HEIGHTFOG_ON)] _HeightFog("HeightFog", Float) = 1
		_FogTexture("FogTexture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _HEIGHTFOG_ON
		#pragma shader_feature_local _ISMETALLIC_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred nodynlightmap nofog 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;
		uniform float FogStart;
		uniform float FogRange;
		uniform float4 FogColor;
		uniform sampler2D _FogTexture;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			float4 temp_output_10_0_g12 = tex2DNode1;
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
			float4 temp_cast_4 = (0.0).xxxx;
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_91_0 = (( ase_worldPos * 0.2 )).xz;
			float mulTime88 = _Time.y * 0.01;
			float2 appendResult94 = (float2(( temp_output_91_0 + ( 0.3 * mulTime88 ) ).x , ( temp_output_91_0 + mulTime88 ).y));
			float2 temp_output_106_0 = (( ase_worldPos * 0.1 )).xz;
			float mulTime109 = _Time.y * 0.01;
			float2 appendResult110 = (float2(( temp_output_106_0 + ( 0.3 * mulTime109 ) ).x , ( temp_output_106_0 + mulTime109 ).y));
			#ifdef _HEIGHTFOG_ON
				float4 staticSwitch15 = ( ( saturate( ( (0.0 + (( ( 1.0 - ase_worldPos.y ) - FogStart ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * FogRange ) ) * FogColor ) * ( tex2D( _FogTexture, appendResult94 ) * tex2D( _FogTexture, appendResult110 ) ) );
			#else
				float4 staticSwitch15 = temp_cast_4;
			#endif
			float4 temp_output_17_0_g12 = staticSwitch15;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g12 = temp_output_10_0_g12;
			#else
				float4 staticSwitch5_g12 = temp_output_17_0_g12;
			#endif
			float temp_output_11_0_g12 = tex2DNode1.a;
			float4 temp_cast_6 = (temp_output_11_0_g12).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g12 = temp_cast_6;
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
				float staticSwitch8_g12 = staticSwitch3_g13;
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
Node;AmplifyShaderEditor.WireNode;23;-45.5,-412.9147;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;-941,-427.5;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;4ac402244bbe234468b5398dcf40e461;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;15;-684.5,-163.9147;Inherit;False;Property;_HeightFog;HeightFog;4;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-885.5,-214.9147;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;22;241.5,-399.9147;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;4;-48.5,-341.125;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;a7b908b89b678c2468527c3a58fbf2e5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;11;-704.5,-58.125;Inherit;False;ase_function_metallic;2;;13;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-2047.007,-127.246;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-1500.008,-126.946;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-1663.866,-125.0443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;72;-1862.107,-207.9459;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1326.407,-127.2727;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1029.767,-136.5874;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;70;-1721.308,43.05328;Inherit;False;Global;FogColor;FogColor;1;0;Create;True;0;0;0;False;0;False;0.503916,0.6292485,0.7169812,0;1,0.05739069,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-2327.008,14.45486;Inherit;False;Global;FogStart;FogStart;3;0;Create;True;0;0;0;False;0;False;30;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2030.609,-5.945813;Inherit;False;Global;FogRange;FogRange;2;0;Create;True;0;0;0;False;0;False;0;247.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-2237.489,-124.8159;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2530.605,-172.0463;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;97;-2263.937,277.0038;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-2398.566,391.5825;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;96;-2248.182,391.5821;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-2394.142,262.8546;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;91;-2605.726,281.1909;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-2613.318,390.205;Inherit;False;2;2;0;FLOAT;0.3;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-1885.828,271.2748;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;102;-2310.789,649.2874;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-2445.418,763.8661;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;104;-2295.034,763.8657;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-2440.994,635.1381;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;106;-2652.579,653.4745;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-2906.462,655.7461;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1932.68,643.5583;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-2859.61,283.4625;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;76;-1692.006,245.0444;Inherit;True;Property;_FogTexture;FogTexture;5;0;Create;True;0;0;0;False;0;False;-1;None;d99d36f57e74748428e02bb24913391d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1316.112,248.5694;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;85;-3146.957,281.7057;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;101;-1687.913,466.9696;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;76;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;88;-2834.869,549.0876;Inherit;False;1;0;FLOAT;-0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-2660.17,762.4886;Inherit;False;2;2;0;FLOAT;0.3;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;109;-2881.721,921.3713;Inherit;False;1;0;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343,-234;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_env_armory;False;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-3185.448,474.6141;Inherit;False;Constant;_FogTilingX;FogTilingX;8;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-3183.3,541.8977;Inherit;False;Constant;_FogTilingY;FogTilingY;9;0;Create;True;0;0;0;False;0;False;0.1;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-3186.972,715.1373;Inherit;False;Constant;_TimeX;TimeX;6;0;Create;True;0;0;0;False;0;False;0.01;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-3186.507,783.4379;Inherit;False;Constant;_TimeY;TimeY;7;0;Create;True;0;0;0;False;0;False;0.01;0.005;0;0;0;1;FLOAT;0
WireConnection;31;10;1;0
WireConnection;31;11;1;4
WireConnection;31;17;15;0
WireConnection;31;13;11;0
WireConnection;23;0;31;0
WireConnection;15;1;32;0
WireConnection;15;0;77;0
WireConnection;22;0;23;0
WireConnection;58;0;59;0
WireConnection;58;1;73;0
WireConnection;66;0;71;0
WireConnection;71;0;72;0
WireConnection;71;1;75;0
WireConnection;72;0;58;0
WireConnection;65;0;66;0
WireConnection;65;1;70;0
WireConnection;77;0;65;0
WireConnection;77;1;112;0
WireConnection;59;0;60;2
WireConnection;97;0;98;0
WireConnection;95;0;91;0
WireConnection;95;1;88;0
WireConnection;96;0;95;0
WireConnection;98;0;91;0
WireConnection;98;1;99;0
WireConnection;91;0;84;0
WireConnection;99;1;88;0
WireConnection;94;0;97;0
WireConnection;94;1;96;1
WireConnection;102;0;105;0
WireConnection;103;0;106;0
WireConnection;103;1;109;0
WireConnection;104;0;103;0
WireConnection;105;0;106;0
WireConnection;105;1;107;0
WireConnection;106;0;108;0
WireConnection;108;0;85;0
WireConnection;108;1;111;0
WireConnection;110;0;102;0
WireConnection;110;1;104;1
WireConnection;84;0;85;0
WireConnection;84;1;89;0
WireConnection;76;1;94;0
WireConnection;112;0;76;0
WireConnection;112;1;101;0
WireConnection;101;1;110;0
WireConnection;88;0;114;0
WireConnection;107;1;109;0
WireConnection;109;0;113;0
WireConnection;0;0;22;0
WireConnection;0;1;4;0
WireConnection;0;2;31;14
WireConnection;0;3;31;15
WireConnection;0;4;31;16
ASEEND*/
//CHKSM=D8892B8B5C249708B8080BF5D80A70DE2F73FFE9