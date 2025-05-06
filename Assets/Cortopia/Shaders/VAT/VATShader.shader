// Upgrade NOTE: upgraded instancing buffer 'VATShader' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VATShader"
{
	Properties
	{
		_Diffuse("Diffuse", 2D) = "white" {}
		_VAT_positions("VAT_positions", 2D) = "white" {}
		_AnimationFps("AnimationFps", Float) = 0
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_State0Start("State0Start", Float) = 0
		_State1Start("State1Start", Float) = 0
		_TransitionStart("TransitionStart", Float) = 0
		_TransitionLength("TransitionLength", Float) = 0
		_StartTime("StartTime", Float) = 0
		_State0Length("State0Length", Float) = 0
		_State1Length("State1Length", Float) = 0
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
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _VAT_positions;
		float4 _VAT_positions_TexelSize;
		uniform float _CurTime;
		uniform float _AnimationFps;
		uniform sampler2D _Diffuse;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;

		UNITY_INSTANCING_BUFFER_START(VATShader)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float2, _Tiling)
#define _Tiling_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float2, _Offset)
#define _Offset_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _StartTime)
#define _StartTime_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _State0Length)
#define _State0Length_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _State0Start)
#define _State0Start_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _TransitionLength)
#define _TransitionLength_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _TransitionStart)
#define _TransitionStart_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _State1Length)
#define _State1Length_arr VATShader
			UNITY_DEFINE_INSTANCED_PROP(float, _State1Start)
#define _State1Start_arr VATShader
		UNITY_INSTANCING_BUFFER_END(VATShader)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float _StartTime_Instance = UNITY_ACCESS_INSTANCED_PROP(_StartTime_arr, _StartTime);
			float temp_output_114_0 = ( ( _CurTime - _StartTime_Instance ) * _AnimationFps );
			float _State0Length_Instance = UNITY_ACCESS_INSTANCED_PROP(_State0Length_arr, _State0Length);
			float temp_output_123_0 = ( temp_output_114_0 - _State0Length_Instance );
			float _State0Start_Instance = UNITY_ACCESS_INSTANCED_PROP(_State0Start_arr, _State0Start);
			float _TransitionLength_Instance = UNITY_ACCESS_INSTANCED_PROP(_TransitionLength_arr, _TransitionLength);
			float temp_output_127_0 = ( temp_output_123_0 - _TransitionLength_Instance );
			float _TransitionStart_Instance = UNITY_ACCESS_INSTANCED_PROP(_TransitionStart_arr, _TransitionStart);
			float _State1Length_Instance = UNITY_ACCESS_INSTANCED_PROP(_State1Length_arr, _State1Length);
			float _State1Start_Instance = UNITY_ACCESS_INSTANCED_PROP(_State1Start_arr, _State1Start);
			float2 appendResult133 = (float2(v.texcoord2.xy.x , ( ( _VAT_positions_TexelSize.y * 0.5 ) + ( _VAT_positions_TexelSize.y * ( temp_output_123_0 < 0.0 ? ( temp_output_114_0 + _State0Start_Instance ) : ( temp_output_127_0 < 0.0 ? ( temp_output_123_0 + _TransitionStart_Instance ) : ( fmod( temp_output_127_0 , _State1Length_Instance ) + _State1Start_Instance ) ) ) ) )));
			float4 tex2DNode2 = tex2Dlod( _VAT_positions, float4( appendResult133, 0, 0.0) );
			float3 appendResult62 = (float3(tex2DNode2.r , tex2DNode2.g , tex2DNode2.b));
			v.vertex.xyz = appendResult62;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float2 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float2 _Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Offset_arr, _Offset);
			float2 uv_TexCoord97 = i.uv_texcoord * _Tiling_Instance + _Offset_Instance;
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
			o.Emission = ( ( _Color_Instance * tex2D( _Diffuse, uv_TexCoord97 ) ) + ( saturate( ( (0.0 + (( staticSwitch22_g1 - staticSwitch27_g1 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g1 ) ) * staticSwitch23_g1 ) ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-694.0587,-650.2423;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;101;-939.0587,-712.2423;Inherit;False;InstancedProperty;_Tiling;Tiling;3;0;Create;True;0;0;0;False;0;False;1,1;0.25,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;99;-426.0576,-681.2423;Inherit;True;Property;_Diffuse;Diffuse;0;0;Create;True;0;0;0;False;0;False;-1;None;37ee88d8cd6630847b26e2adafb1e951;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;102;-939.0587,-550.2423;Inherit;False;InstancedProperty;_Offset;Offset;17;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-2333.55,-400.9553;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-2313.361,-95.24795;Inherit;False;InstancedProperty;_State0Start;State0Start;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;123;-2020.226,-235.2611;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-2023.211,-120.4622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-2060.603,37.42345;Inherit;False;InstancedProperty;_TransitionLength;TransitionLength;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-2034.439,140.4009;Inherit;False;InstancedProperty;_TransitionStart;TransitionStart;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;-1764.849,115.4762;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1817.221,230.2514;Inherit;False;InstancedProperty;_State1Length;State1Length;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1780.918,324.9528;Inherit;False;InstancedProperty;_State1Start;State1Start;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;118;-1596.89,204.2751;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2673.449,-246.8553;Inherit;False;Property;_AnimationFps;AnimationFps;2;0;Create;True;0;0;0;False;0;False;0;24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;125;-1172.611,-35.01157;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-2329.327,-229.6991;Inherit;False;InstancedProperty;_State0Length;State0Length;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;126;-1335.767,83.52036;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;608.5154,-658.2188;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;VATShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;115.9422,-698.2423;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-1007.613,-143.4862;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexelSizeNode;131;-1287.484,-387.9076;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;22;-1564.444,-462.5923;Inherit;True;Property;_VAT_positions;VAT_positions;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;62;-225.3782,-418.5333;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;133;-703.1782,-325.9937;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1005.713,-247.8351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-853.2648,-199.6998;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-534.6523,-443.3844;Inherit;True;Property;_PositionVAT;PositionVAT;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-1474.699,268.7389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;127;-1762.692,1.401055;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;113;-2483.849,-418.1553;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1004.038,-379.9774;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;110;-2662.95,-348.7551;Inherit;False;InstancedProperty;_StartTime;StartTime;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-2718.133,-448.7759;Inherit;False;Global;_CurTime;_CurTime;14;0;Create;True;0;0;0;False;0;False;0;6.517784;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;100;-143.0576,-934.2424;Inherit;False;InstancedProperty;_Color;_Color;18;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;139;272.0891,-694.4188;Inherit;False;ase_function_heightFog;4;;1;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
WireConnection;97;0;101;0
WireConnection;97;1;102;0
WireConnection;99;1;97;0
WireConnection;114;0;113;0
WireConnection;114;1;112;0
WireConnection;123;0;114;0
WireConnection;123;1;117;0
WireConnection;115;0;114;0
WireConnection;115;1;109;0
WireConnection;128;0;123;0
WireConnection;128;1;121;0
WireConnection;118;0;127;0
WireConnection;118;1;120;0
WireConnection;125;0;123;0
WireConnection;125;2;115;0
WireConnection;125;3;126;0
WireConnection;126;0;127;0
WireConnection;126;2;128;0
WireConnection;126;3;129;0
WireConnection;0;2;139;0
WireConnection;0;11;62;0
WireConnection;98;0;100;0
WireConnection;98;1;99;0
WireConnection;134;0;131;2
WireConnection;134;1;125;0
WireConnection;131;0;22;0
WireConnection;62;0;2;1
WireConnection;62;1;2;2
WireConnection;62;2;2;3
WireConnection;133;0;45;1
WireConnection;133;1;135;0
WireConnection;132;0;131;2
WireConnection;135;0;132;0
WireConnection;135;1;134;0
WireConnection;2;0;22;0
WireConnection;2;1;133;0
WireConnection;129;0;118;0
WireConnection;129;1;119;0
WireConnection;127;0;123;0
WireConnection;127;1;122;0
WireConnection;113;0;136;0
WireConnection;113;1;110;0
WireConnection;139;16;98;0
ASEEND*/
//CHKSM=4326002E514F4044EFF75636E64A096826935478