// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_bloodFlow"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		[Toggle(_BACKDROPHEIGHTFOG_ON)] _BackdropHeightFog("BackdropHeightFog", Float) = 0
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_Color0("Color 0", Color) = (0.745283,0.1143789,0.03867035,0)
		_Smoothness("Smoothness", Float) = 0.75
		_Vector0("Vector 0", Vector) = (10,10,0,0)
		_Vector1("Vector 1", Vector) = (9,9,0,0)
		_TimeScale("TimeScale", Float) = 0.02
		[Toggle(_SCROLL_BOTH_IN_X_ON)] _Scroll_both_in_X("Scroll_both_in_X", Float) = 0
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
		#pragma shader_feature_local _BACKDROPHEIGHTFOG_ON
		#pragma shader_feature_local _SCROLL_BOTH_IN_X_ON
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nodynlightmap nofog noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color0;
		uniform sampler2D _Albedo;
		uniform float2 _Vector0;
		uniform float _TimeScale;
		uniform float2 _Vector1;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime53 = _Time.y * _TimeScale;
			float2 appendResult55 = (float2(mulTime53 , 0.0));
			float2 uv_TexCoord54 = i.uv_texcoord * _Vector0 + appendResult55;
			float4 tex2DNode57 = tex2D( _Albedo, uv_TexCoord54 );
			float2 appendResult58 = (float2(0.0 , mulTime53));
			float2 appendResult91 = (float2(mulTime53 , 0.0));
			#ifdef _SCROLL_BOTH_IN_X_ON
				float2 staticSwitch90 = appendResult91;
			#else
				float2 staticSwitch90 = appendResult58;
			#endif
			float2 uv_TexCoord59 = i.uv_texcoord * _Vector1 + staticSwitch90;
			float4 tex2DNode60 = tex2D( _Albedo, uv_TexCoord59 );
			float4 temp_output_63_0 = ( _Color0 * ( tex2DNode57 + tex2DNode60 ) );
			float3 ase_worldPos = i.worldPos;
			#ifdef _FLIPFOG_ON
				float staticSwitch22_g1 = ( 1.0 - ase_worldPos.y );
			#else
				float staticSwitch22_g1 = ase_worldPos.y;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch27_g1 = FogStart;
			#else
				float staticSwitch27_g1 = _FogStart;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch25_g1 = FogRange;
			#else
				float staticSwitch25_g1 = _FogRange;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float4 staticSwitch23_g1 = FogColor;
			#else
				float4 staticSwitch23_g1 = _FogColor;
			#endif
			#ifdef _BACKDROPHEIGHTFOG_ON
				float4 staticSwitch93 = ( temp_output_63_0 + ( float4( 0,0,0,0 ) + ( saturate( ( (0.0 + (( staticSwitch22_g1 - staticSwitch27_g1 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g1 ) ) * staticSwitch23_g1 ) ) );
			#else
				float4 staticSwitch93 = temp_output_63_0;
			#endif
			float4 temp_output_10_0_g2 = staticSwitch93;
			float4 temp_cast_3 = (0.0).xxxx;
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g2 = temp_cast_3;
			#else
				float4 staticSwitch2_g2 = temp_output_10_0_g2;
			#endif
			float4 temp_cast_4 = (0.0).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch1_g2 = temp_cast_4;
			#else
				float4 staticSwitch1_g2 = staticSwitch2_g2;
			#endif
			o.Albedo = staticSwitch1_g2.xyz;
			float4 temp_output_17_0_g2 = float4( 0,0,0,0 );
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g2 = temp_output_10_0_g2;
			#else
				float4 staticSwitch5_g2 = temp_output_17_0_g2;
			#endif
			float temp_output_11_0_g2 = saturate( ( ( tex2DNode57.a + tex2DNode60.a ) * _Smoothness ) );
			float4 temp_cast_6 = (temp_output_11_0_g2).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch6_g2 = temp_cast_6;
			#else
				float4 staticSwitch6_g2 = temp_output_17_0_g2;
			#endif
			#ifdef _SmoothnessView
				float4 staticSwitch3_g2 = staticSwitch6_g2;
			#else
				float4 staticSwitch3_g2 = staticSwitch5_g2;
			#endif
			o.Emission = staticSwitch3_g2.xyz;
			#ifdef _SmoothnessView
				float staticSwitch4_g2 = 0.0;
			#else
				float staticSwitch4_g2 = temp_output_11_0_g2;
			#endif
			#ifdef _DiffuseOnlyMode
				float staticSwitch7_g2 = 0.0;
			#else
				float staticSwitch7_g2 = staticSwitch4_g2;
			#endif
			o.Smoothness = staticSwitch7_g2;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SamplerNode;60;-484.4326,-927.921;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;57;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;53;-1612.41,-1009.19;Inherit;False;1;0;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1854.316,-1009.281;Inherit;False;Property;_TimeScale;TimeScale;12;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1312.832,-948.9203;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-1313.579,-848.8107;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;87;-1031.258,-1144.274;Inherit;False;Property;_Vector0;Vector 0;10;0;Create;True;0;0;0;False;0;False;10,10;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-744.7322,-911.7206;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;9,9;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-749.814,-1061.336;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-25.23303,-1063.421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;152.8668,-1093.321;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-31.73318,-936.8212;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-93.69247,-820.2484;Inherit;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;0;False;0;False;0.75;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;141.0649,-842.8067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;74;320.5264,-843.2739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;88;-1006.258,-937.274;Inherit;False;Property;_Vector1;Vector 1;11;0;Create;True;0;0;0;False;0;False;9,9;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1309.225,-1054.949;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;90;-1097.964,-812.6567;Inherit;False;Property;_Scroll_both_in_X;Scroll_both_in_X;13;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;92;143.7599,-984.894;Inherit;False;ase_function_heightFog;2;;1;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;450.9006,-1027.001;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;93;590.8466,-1090.162;Inherit;False;Property;_BackdropHeightFog;BackdropHeightFog;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;57;-487.6611,-1134.573;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;13945e88870832c43b38381b3efbf90a;13945e88870832c43b38381b3efbf90a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-421.4373,-1323.313;Inherit;False;Property;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0.745283,0.1143789,0.03867035,0;0.745283,0.1143789,0.03867035,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;96;934.3706,-936.6645;Inherit;False;ase_function_DifSmooth;-1;;2;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;97;1216.948,-938.3564;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_bloodFlow;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;1;59;0
WireConnection;53;0;89;0
WireConnection;58;1;53;0
WireConnection;91;0;53;0
WireConnection;59;0;88;0
WireConnection;59;1;90;0
WireConnection;54;0;87;0
WireConnection;54;1;55;0
WireConnection;62;0;57;0
WireConnection;62;1;60;0
WireConnection;63;0;6;0
WireConnection;63;1;62;0
WireConnection;64;0;57;4
WireConnection;64;1;60;4
WireConnection;72;0;64;0
WireConnection;72;1;73;0
WireConnection;74;0;72;0
WireConnection;55;0;53;0
WireConnection;90;1;58;0
WireConnection;90;0;91;0
WireConnection;95;0;63;0
WireConnection;95;1;92;0
WireConnection;93;1;63;0
WireConnection;93;0;95;0
WireConnection;57;1;54;0
WireConnection;96;10;93;0
WireConnection;96;11;74;0
WireConnection;97;0;96;0
WireConnection;97;2;96;14
WireConnection;97;4;96;16
ASEEND*/
//CHKSM=C6A3137752E46CE2AA5A4A0F3C7EC80A974A1A4A