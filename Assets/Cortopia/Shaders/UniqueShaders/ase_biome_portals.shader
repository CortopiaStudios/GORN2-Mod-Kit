// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_biome_portals"
{
	Properties
	{
		_ParallaxTexture1("Parallax Texture 1", 2DArray) = "white" {}
		_Swirl("Swirl", 2D) = "white" {}
		_BiomeColor("BiomeColor", Color) = (0.972549,0.4534461,0.08627448,0)
		_ActivatedPortal("ActivatedPortal", Range( 0 , 2)) = 0
		_LevelsInt("LevelsInt", Int) = 0
		_EnterablePortal("EnterablePortal", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D_ARRAY(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D_ARRAY(tex,samplertex,coord) tex2DArray(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_ParallaxTexture1);
		uniform sampler2D _Swirl;
		uniform float _ActivatedPortal;
		SamplerState sampler_ParallaxTexture1;
		uniform float4 _BiomeColor;
		uniform float _EnterablePortal;
		uniform int _LevelsInt;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord5 = i.uv_texcoord * float2( 0.03,0.03 ) + float2( 0.5,0.5 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			float2 Offset4 = ( ( 0.3 - 1 ) * ase_tanViewDir.xy * 0.7 ) + uv_TexCoord5;
			float2 uv_TexCoord174 = i.uv_texcoord * float2( 0.5,0.5 ) + float2( 0.25,0.25 );
			float2 Offset172 = ( ( 0.4 - 1 ) * ase_tanViewDir.xy * 0.6 ) + uv_TexCoord174;
			float cos87 = cos( -0.4 * _Time.y );
			float sin87 = sin( -0.4 * _Time.y );
			float2 rotator87 = mul( Offset172 - float2( 0.5,0.5 ) , float2x2( cos87 , -sin87 , sin87 , cos87 )) + float2( 0.5,0.5 );
			float cos171 = cos( -0.3 * _Time.y );
			float sin171 = sin( -0.3 * _Time.y );
			float2 rotator171 = mul( Offset172 - float2( 0.5,0.5 ) , float2x2( cos171 , -sin171 , sin171 , cos171 )) + float2( 0.5,0.5 );
			float4 temp_output_181_0 = ( ( tex2D( _Swirl, rotator87 ) * 0.5 ) + ( 0.5 * tex2D( _Swirl, rotator171 ) ) );
			float ActivatePortal279 = _ActivatedPortal;
			float4 lerpResult276 = lerp( ( 0.01 * temp_output_181_0 ) , temp_output_181_0 , ActivatePortal279);
			float4 tex2DArrayNode244 = SAMPLE_TEXTURE2D_ARRAY( _ParallaxTexture1, sampler_ParallaxTexture1, float3(( float4( Offset4, 0.0 , 0.0 ) + lerpResult276 ).rg,0.0) );
			float temp_output_231_0 = (0.0 + (_EnterablePortal - 0.0) * (0.4 - 0.0) / (1.0 - 0.0));
			float smoothstepResult217 = smoothstep( ( temp_output_231_0 - 0.1 ) , temp_output_231_0 , distance( ( Offset172 + float2( -0.5,-0.5 ) ) , float2( 0,0 ) ));
			float4 temp_output_212_0 = ( ( tex2DArrayNode244 + ( temp_output_181_0 + _BiomeColor ) ) * saturate( ( ( _BiomeColor * 0.2 ) + smoothstepResult217 ) ) );
			float4 lerpResult245 = lerp( tex2DArrayNode244 , temp_output_212_0 , _ActivatedPortal);
			float EnterablePortal275 = _EnterablePortal;
			float4 lerpResult272 = lerp( lerpResult245 , ( SAMPLE_TEXTURE2D_ARRAY( _ParallaxTexture1, sampler_ParallaxTexture1, float3(( float4( Offset4, 0.0 , 0.0 ) + ( temp_output_181_0 * (0.01 + (_EnterablePortal - 1.0) * (0.1 - 0.01) / (0.0 - 1.0)) ) ).rg,(float)_LevelsInt) ) + temp_output_212_0 ) , EnterablePortal275);
			o.Emission = lerpResult272.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.RangedFloatNode;189;-585.04,49.62715;Inherit;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-412.4108,120.8114;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0.5,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;169;-1983.698,292.2328;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;168;-2006.477,131.268;Inherit;False;Constant;_SwirlHeight2;SwirlHeight2;3;0;Create;True;0;0;0;False;0;False;0.4;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;167;-2267.069,-28.06158;Inherit;False;Constant;_OffsetSwirl2;OffsetSwirl2;4;0;Create;True;0;0;0;False;0;False;0.25,0.25;0.25,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;175;-2275.069,-158.0618;Inherit;False;Constant;_TilingSwirl2;TilingSwirl2;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;170;-1902.478,215.9921;Inherit;False;Constant;_SwirlScale2;SwirlScale2;3;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;174;-1974.339,-6.151891;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0.25,0.25;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;132;-1111.931,-412.5071;Inherit;False;Constant;_Offset;Offset;6;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.48;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ParallaxMappingNode;172;-1519.05,175.867;Inherit;False;Normal;4;0;FLOAT2;1,1;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-179.2545,-54.82996;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-784.8457,-570.6967;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.03,0.03;False;1;FLOAT2;0.5,0.45;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-740.8976,-265.9707;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;131;-1111.931,-544.507;Inherit;False;Constant;_Tiling;Tiling;6;0;Create;True;0;0;0;False;0;False;0.03,0.03;0.015,0.015;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;224;-941.1212,441.9333;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-410.1628,-54.08078;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;211;-457.6878,446.9821;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;272;1706.662,-94.85458;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;245;1334.625,-102.02;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;194;371.9425,-52.59098;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;96;91.36449,15.95224;Inherit;False;Property;_BiomeColor;BiomeColor;2;0;Create;True;0;0;0;False;0;False;0.972549,0.4534461,0.08627448,0;0.1059095,0.6415094,0.1242206,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;4;-454.3203,-419.9052;Inherit;False;Normal;4;0;FLOAT2;1,1;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-808.8583,-345.6642;Inherit;False;Constant;_BackgroundScale;BackgroundScale;4;0;Create;True;0;0;0;False;0;False;0.7;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;173;-868.386,146.9902;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;daf765042a55b274dbf86202d52ae37b;True;0;False;white;LockedToTexture2D;False;Instance;71;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;141;-815.3627,-425.0804;Inherit;False;Constant;_BackgroundHeight;BackgroundHeight;5;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-556.6848,265.8172;Inherit;False;Property;_EnterablePortal;EnterablePortal;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;230;-164.2394,46.6786;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0.01;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;1341.576,-219.6532;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;425.1621,118.377;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;257;255.2868,198.1594;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;236;207.0358,459.0303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;217;362.2289,351.4749;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;232;135.907,285.2494;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;1123.322,-75.01626;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;946.8181,-73.54789;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;220;914.4907,36.08257;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;271;705.4053,117.9921;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;244;586.9586,-309.8776;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;a13cf53b0787bee4c99e64a0a1bb6e64;True;0;False;white;LockedToTexture2DArray;False;Instance;1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;252;456.3979,-285.0595;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;583.7894,-500.4169;Inherit;True;Property;_ParallaxTexture1;Parallax Texture 1;0;0;Create;True;0;0;0;False;0;False;-1;None;4951d8642d36126468ebb74ca5bc7919;True;0;False;white;LockedToTexture2DArray;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;85;393.1091,-571.1438;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;197.2718,-430.7466;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;-191.1013,233.5731;Inherit;False;EnterablePortal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;1433.278,32.57306;Inherit;False;275;EnterablePortal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;75.20954,-247.8088;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;276;247.6461,-224.3575;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;33.82402,-109.8597;Inherit;False;279;ActivatePortal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;279;1257.434,155.0026;Inherit;False;ActivatePortal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-862.5807,-48.83088;Inherit;True;Property;_Swirl;Swirl;1;0;Create;True;0;0;0;False;0;False;-1;None;daf765042a55b274dbf86202d52ae37b;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;171;-1105.647,173.4767;Inherit;False;3;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;-0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;87;-1100.08,-24.95741;Inherit;False;3;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;-0.4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-159.1161,-248.6513;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;231;-162.3601,317.6399;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;243;379.1938,-375.7915;Inherit;False;Property;_LevelsInt;LevelsInt;4;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;281;1907.479,-144.3421;Float;False;True;-1;3;ASEMaterialInspector;0;0;Unlit;ase_biome_portals;False;False;False;False;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;247;901.6382,156.2036;Inherit;False;Property;_ActivatedPortal;ActivatedPortal;3;0;Create;True;0;0;0;False;0;False;0;0.002;0;2;0;1;FLOAT;0
WireConnection;184;0;189;0
WireConnection;184;1;173;0
WireConnection;174;0;175;0
WireConnection;174;1;167;0
WireConnection;172;0;174;0
WireConnection;172;1;168;0
WireConnection;172;2;170;0
WireConnection;172;3;169;0
WireConnection;181;0;233;0
WireConnection;181;1;184;0
WireConnection;5;0;131;0
WireConnection;5;1;132;0
WireConnection;224;0;172;0
WireConnection;233;0;71;0
WireConnection;233;1;189;0
WireConnection;211;0;224;0
WireConnection;272;0;245;0
WireConnection;272;1;273;0
WireConnection;272;2;274;0
WireConnection;245;0;244;0
WireConnection;245;1;212;0
WireConnection;245;2;247;0
WireConnection;194;0;181;0
WireConnection;194;1;96;0
WireConnection;4;0;5;0
WireConnection;4;1;141;0
WireConnection;4;2;8;0
WireConnection;4;3;6;0
WireConnection;173;1;171;0
WireConnection;230;0;216;0
WireConnection;273;0;1;0
WireConnection;273;1;212;0
WireConnection;269;0;96;0
WireConnection;269;1;257;0
WireConnection;236;0;211;0
WireConnection;217;0;236;0
WireConnection;217;1;232;0
WireConnection;217;2;231;0
WireConnection;232;0;231;0
WireConnection;212;0;117;0
WireConnection;212;1;220;0
WireConnection;117;0;244;0
WireConnection;117;1;194;0
WireConnection;220;0;271;0
WireConnection;271;0;269;0
WireConnection;271;1;217;0
WireConnection;244;1;252;0
WireConnection;252;0;4;0
WireConnection;252;1;276;0
WireConnection;1;1;85;0
WireConnection;1;6;243;0
WireConnection;85;0;4;0
WireConnection;85;1;88;0
WireConnection;88;0;181;0
WireConnection;88;1;230;0
WireConnection;275;0;216;0
WireConnection;278;0;253;0
WireConnection;278;1;181;0
WireConnection;276;0;278;0
WireConnection;276;1;181;0
WireConnection;276;2;280;0
WireConnection;279;0;247;0
WireConnection;71;1;87;0
WireConnection;171;0;172;0
WireConnection;87;0;172;0
WireConnection;231;0;216;0
WireConnection;281;2;272;0
ASEEND*/
//CHKSM=42FE7ABA65A7DFA9AA19D0464ADE375802BA10B4