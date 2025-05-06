// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_crowd_flipbook"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_Color("Color", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime66 = _Time.y * -10.0;
			float2 appendResult130 = (float2(0.0 , ( floor( ( mulTime66 + 4.0 ) ) / 4.0 )));
			float2 uv_TexCoord114 = i.uv_texcoord * float2( 1,0.25 ) + appendResult130;
			float4 tex2DNode1 = tex2Dbias( _Albedo, float4( uv_TexCoord114, 0, -1.0) );
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
			o.Emission = ( ( _Color * tex2DNode1 ) + ( saturate( ( (0.0 + (( staticSwitch22_g1 - staticSwitch27_g1 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g1 ) ) * staticSwitch23_g1 ) ).xyz;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleDivideOpNode;75;-1220.047,20.98151;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;62;-1436.047,-46.01862;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1738.277,43.42729;Inherit;False;Constant;_Rows;Rows;5;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1562.049,-46.01839;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;114;-882.1123,-49.6369;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.25;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;130;-1072.205,-2.528442;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-638,-74;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipBias;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;-1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;66;-1771.455,-46.4146;Inherit;False;1;0;FLOAT;-10;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;144;205.8773,-117.2271;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_crowd_flipbook;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-310.4965,-104.5541;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;147;-604.4965,-242.5541;Inherit;False;Property;_Color;Color;8;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;149;-124.9608,-101.2549;Inherit;False;ase_function_heightFog;2;;1;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
WireConnection;75;0;62;0
WireConnection;75;1;46;0
WireConnection;62;0;76;0
WireConnection;76;0;66;0
WireConnection;76;1;46;0
WireConnection;114;1;130;0
WireConnection;130;1;75;0
WireConnection;1;1;114;0
WireConnection;144;2;149;0
WireConnection;144;10;1;4
WireConnection;146;0;147;0
WireConnection;146;1;1;0
WireConnection;149;16;146;0
ASEEND*/
//CHKSM=7FBFD13254A45CB858F0CB6B8486DCCCCF188801