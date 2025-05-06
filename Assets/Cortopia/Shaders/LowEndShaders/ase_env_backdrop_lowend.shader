// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/_LowEnd/ase_env_backdrop_lowend"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "black" {}
		[Toggle(_HEIGHTFOG_ON)] _HeightFog("HeightFog", Float) = 1
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		[Toggle(_HAVELIGHTMAPS_ON)] _HaveLightmaps("HaveLightmaps", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _SmoothnessView
		#pragma shader_feature _DiffuseOnlyMode
		#pragma shader_feature_local _HEIGHTFOG_ON
		#pragma shader_feature_local _HAVELIGHTMAPS_ON
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred nodynlightmap nofog noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 vertexToFrag10_g11;
			float3 worldPos;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.vertexToFrag10_g11 = ( ( v.texcoord1.xy * (unity_LightmapST).xy ) + (unity_LightmapST).zw );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float4 tex2DNode7_g11 = UNITY_SAMPLE_TEX2D( unity_Lightmap, i.vertexToFrag10_g11 );
			float3 decodeLightMap6_g11 = DecodeLightmap(tex2DNode7_g11);
			#ifdef _HAVELIGHTMAPS_ON
				float4 staticSwitch16 = ( tex2DNode1 * float4( decodeLightMap6_g11 , 0.0 ) );
			#else
				float4 staticSwitch16 = tex2DNode1;
			#endif
			float3 ase_worldPos = i.worldPos;
			#ifdef _FLIPFOG_ON
				float staticSwitch22_g12 = ( 1.0 - ase_worldPos.y );
			#else
				float staticSwitch22_g12 = ase_worldPos.y;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch27_g12 = FogStart;
			#else
				float staticSwitch27_g12 = _FogStart;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float staticSwitch25_g12 = FogRange;
			#else
				float staticSwitch25_g12 = _FogRange;
			#endif
			#ifdef _USEGLOBALFOGVALUES_ON
				float4 staticSwitch23_g12 = FogColor;
			#else
				float4 staticSwitch23_g12 = _FogColor;
			#endif
			#ifdef _HEIGHTFOG_ON
				float4 staticSwitch10 = ( staticSwitch16 + ( saturate( ( (0.0 + (( staticSwitch22_g12 - staticSwitch27_g12 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g12 ) ) * staticSwitch23_g12 ) );
			#else
				float4 staticSwitch10 = staticSwitch16;
			#endif
			#ifdef _DiffuseOnlyMode
				float4 staticSwitch20 = tex2DNode1;
			#else
				float4 staticSwitch20 = staticSwitch10;
			#endif
			float4 temp_cast_5 = (tex2DNode1.a).xxxx;
			#ifdef _SmoothnessView
				float4 staticSwitch24 = temp_cast_5;
			#else
				float4 staticSwitch24 = staticSwitch20;
			#endif
			o.Emission = staticSwitch24.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-635.9468,-213.3505;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;4;-894.103,-153.1359;Inherit;False;FetchLightmapValue;9;;11;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;24;625.532,-222.281;Inherit;False;Property;_SmoothnessView;SmoothnessView;6;0;Create;True;0;0;0;False;0;False;0;0;0;False;_SmoothnessView;Toggle;2;Key0;Key1;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;20;367.9069,-221.556;Inherit;False;Property;_DiffuseOnlyMode;DiffuseOnlyMode;7;0;Create;True;0;0;0;False;0;False;0;0;0;False;_DiffuseOnlyMode;Toggle;2;Key0;Key1;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;18;-179.1707,-198.8729;Inherit;False;ase_function_heightFog;2;;12;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;10;117.9765,-273.7786;Inherit;False;Property;_HeightFog;HeightFog;1;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;16;-460.3707,-276.1213;Inherit;False;Property;_HaveLightmaps;HaveLightmaps;8;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1287.455,-274.2027;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;21;123.9069,-63.556;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;22;-896.0931,-72.556;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;25;-883.5682,-20.08101;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;26;416.932,-42.08101;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;855.2012,-268.1923;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Cortopia/_LowEnd/ase_env_backdrop_lowend;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;5;1;4;0
WireConnection;24;1;20;0
WireConnection;24;0;26;0
WireConnection;20;1;10;0
WireConnection;20;0;21;0
WireConnection;18;16;16;0
WireConnection;10;1;16;0
WireConnection;10;0;18;0
WireConnection;16;1;1;0
WireConnection;16;0;5;0
WireConnection;21;0;22;0
WireConnection;22;0;1;0
WireConnection;25;0;1;4
WireConnection;26;0;25;0
WireConnection;0;2;24;0
ASEEND*/
//CHKSM=6B09C70949728BFD74C5A83D0DB5C761118D7F22