// Upgrade NOTE: upgraded instancing buffer 'ase_crowd_props' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_crowd_props"
{
	Properties
	{
		_Diffuse("Diffuse", 2D) = "white" {}
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		[Toggle(_UVOFFSETENABLED_ON)] _UVOffsetEnabled("UV Offset Enabled", Float) = 0
		_Offset("Offset", Vector) = (0,0,0,0)
		_Color("_Color", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature_local _UVOFFSETENABLED_ON
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Diffuse;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;

		UNITY_INSTANCING_BUFFER_START(ase_crowd_props)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr ase_crowd_props
			UNITY_DEFINE_INSTANCED_PROP(float2, _Offset)
#define _Offset_arr ase_crowd_props
		UNITY_INSTANCING_BUFFER_END(ase_crowd_props)

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float2 _Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Offset_arr, _Offset);
			float2 uv_TexCoord97 = i.uv_texcoord * float2( 1,1 ) + _Offset_Instance;
			#ifdef _UVOFFSETENABLED_ON
				float2 staticSwitch140 = uv_TexCoord97;
			#else
				float2 staticSwitch140 = i.uv_texcoord;
			#endif
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
			o.Emission = ( ( _Color_Instance * tex2D( _Diffuse, staticSwitch140 ) ) + ( saturate( ( (0.0 + (( staticSwitch22_g1 - staticSwitch27_g1 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g1 ) ) * staticSwitch23_g1 ) ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SamplerNode;99;-397.1089,-587.5034;Inherit;True;Property;_Diffuse;Diffuse;0;0;Create;True;0;0;0;False;0;False;-1;None;37ee88d8cd6630847b26e2adafb1e951;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;608.5154,-658.2188;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_crowd_props;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;100;-148.5716,-847.3961;Inherit;False;InstancedProperty;_Color;_Color;9;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;114.5637,-524.5495;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;139;270.7106,-526.2403;Inherit;False;ase_function_heightFog;1;;1;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;101;-1170.649,-563.3622;Inherit;False;Constant;_Tiling;Tiling;7;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;102;-1170.649,-401.3631;Inherit;False;InstancedProperty;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-925.6487,-501.3625;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;141;-949.5271,-692.0658;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;140;-687.6092,-563.8636;Inherit;False;Property;_UVOffsetEnabled;UV Offset Enabled;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
WireConnection;99;1;140;0
WireConnection;0;2;139;0
WireConnection;98;0;100;0
WireConnection;98;1;99;0
WireConnection;139;16;98;0
WireConnection;97;0;101;0
WireConnection;97;1;102;0
WireConnection;140;1;141;0
WireConnection;140;0;97;0
ASEEND*/
//CHKSM=AB04500FF79A155B861538B2AE657FBF2E404790