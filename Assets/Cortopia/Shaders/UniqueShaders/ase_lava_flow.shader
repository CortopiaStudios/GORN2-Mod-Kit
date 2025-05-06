// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_lava_flow"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		[Toggle(_FLIPFOG_ON)] _FlipFog("Flip Fog", Float) = 0
		_FogColor("FogColor", Color) = (0.503916,0.6292485,0.7169812,0)
		[Toggle(_USEGLOBALFOGVALUES_ON)] _UseGlobalFogvalues("UseGlobalFogvalues", Float) = 1
		_FogRange("FogRange", Float) = 0
		_FogStart("FogStart", Float) = 30
		_MainTex2("_MainTex2", 2D) = "white" {}
		_Tiling_U("Tiling_U", Float) = 12
		_Tex2Tiling_U("Tex2Tiling_U", Float) = 12
		_Tiling_V("Tiling_V", Float) = 12
		_Tex2Tiling_V("Tex2Tiling_V", Float) = 12
		_Tiling2_U("Tiling2_U", Float) = 13
		_Tiling2_V("Tiling2_V", Float) = 13
		_Speed("Speed", Float) = 0.1
		_Float0("Float 0", Float) = 0.1
		_Speed2("Speed2", Float) = 0.1
		_Color0("Color 0", Color) = (0,0,0,0)
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
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
		#pragma shader_feature_local _FLIPFOG_ON
		#pragma shader_feature_local _USEGLOBALFOGVALUES_ON
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _MainTex2;
		uniform float _Tex2Tiling_U;
		uniform float _Tex2Tiling_V;
		uniform float _Float0;
		uniform float4 _Color2;
		uniform sampler2D _MainTex;
		uniform float _Tiling_U;
		uniform float _Tiling_V;
		uniform float _Speed;
		uniform float _Tiling2_U;
		uniform float _Tiling2_V;
		uniform float _Speed2;
		uniform float4 _Color0;
		uniform float _FogStart;
		uniform float FogStart;
		uniform float _FogRange;
		uniform float FogRange;
		uniform float4 _FogColor;
		uniform float4 FogColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult120 = (float2(_Tex2Tiling_U , _Tex2Tiling_V));
			float mulTime124 = _Time.y * _Float0;
			float2 appendResult121 = (float2(( 0.0 * mulTime124 ) , mulTime124));
			float2 uv_TexCoord119 = i.uv_texcoord * appendResult120 + appendResult121;
			float4 tex2DNode116 = tex2D( _MainTex2, uv_TexCoord119 );
			float2 appendResult94 = (float2(_Tiling_U , _Tiling_V));
			float mulTime58 = _Time.y * _Speed;
			float2 appendResult95 = (float2(( 0.5 * mulTime58 ) , mulTime58));
			float2 uv_TexCoord26 = i.uv_texcoord * appendResult94 + appendResult95;
			float2 uv_TexCoord114 = i.uv_texcoord * float2( 1,1.26 ) + float2( 0,0.18 );
			float temp_output_131_0 = ( saturate( tex2DNode116.r ) - pow( saturate( uv_TexCoord114.y ) , 4.37 ) );
			float4 lerpResult117 = lerp( ( tex2DNode116.r * _Color2 ) , tex2D( _MainTex, uv_TexCoord26 ) , saturate( ( temp_output_131_0 / ( 1.0 - temp_output_131_0 ) ) ));
			float2 appendResult101 = (float2(_Tiling2_U , _Tiling2_V));
			float mulTime104 = _Time.y * _Speed2;
			float2 appendResult103 = (float2(( -0.5 * mulTime104 ) , mulTime104));
			float2 uv_TexCoord100 = i.uv_texcoord * appendResult101 + appendResult103;
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
			o.Emission = ( ( ( lerpResult117 + tex2D( _MainTex, uv_TexCoord100 ) ) + _Color0 ) + ( float4( 0,0,0,0 ) + ( saturate( ( (0.0 + (( staticSwitch22_g1 - staticSwitch27_g1 ) - 0.0) * (0.001 - 0.0) / (1.0 - 0.0)) * staticSwitch25_g1 ) ) * staticSwitch23_g1 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.TextureCoordinatesNode;100;-1751.27,-139.2971;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;101;-1936.714,-145.6827;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;103;-2196.199,23.33627;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;104;-2557.551,47.40248;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2357.429,-8.08963;Inherit;False;2;2;0;FLOAT;-0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2737.429,42.91037;Inherit;False;Property;_Speed2;Speed2;16;0;Create;True;0;0;0;False;0;False;0.1;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-2150.623,-168.2458;Inherit;False;Property;_Tiling2_U;Tiling2_U;12;0;Create;True;0;0;0;False;0;False;13;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-2147.083,-88.91101;Inherit;False;Property;_Tiling2_V;Tiling2_V;13;0;Create;True;0;0;0;False;0;False;13;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1745.014,-399.4455;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;94;-1930.458,-405.8311;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;95;-2213.943,-286.8121;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-2375.173,-318.238;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-2755.173,-267.238;Inherit;False;Property;_Speed;Speed;14;0;Create;True;0;0;0;False;0;False;0.1;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;58;-2575.295,-262.7459;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2148.367,-518.3942;Inherit;False;Property;_Tiling_U;Tiling_U;8;0;Create;True;0;0;0;False;0;False;12;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2150.083,-374.911;Inherit;False;Property;_Tiling_V;Tiling_V;10;0;Create;True;0;0;0;False;0;False;12;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;120;-2360.811,-877.1332;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-2644.296,-758.1143;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;124;-3005.648,-734.0481;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2578.72,-989.6964;Inherit;False;Property;_Tex2Tiling_U;Tex2Tiling_U;9;0;Create;True;0;0;0;False;0;False;12;1.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-2580.436,-846.2131;Inherit;False;Property;_Tex2Tiling_V;Tex2Tiling_V;11;0;Create;True;0;0;0;False;0;False;12;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-2805.526,-789.5402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-3185.526,-738.5402;Inherit;False;Property;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;119;-2259.367,-890.7477;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;98;-1490.173,99.76199;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;4e6915e0c45f8a04da3fa7fe4663721a;True;0;False;white;Auto;False;Instance;9;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1489.885,-90.40561;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;4e6915e0c45f8a04da3fa7fe4663721a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;111;-1378.083,303.089;Inherit;False;Property;_Color0;Color 0;17;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6320754,0.2148858,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;132;-1774.69,-1303.866;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;131;-1231.938,-814.2767;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;134;-913.0697,-814.4432;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;114;-1999.48,-1346.748;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1.26;False;1;FLOAT2;0,0.18;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;136;-1552.588,-1174.79;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-1907.091,-776.8436;Inherit;True;Property;_MainTex2;_MainTex2;7;0;Create;True;0;0;0;False;0;False;-1;None;dfefd45a87f80d344ad079e21d5da47c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;130;-1533.047,-819.1648;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;133;-1037.941,-681.6608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;135;-684.8086,-640.3439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;139;-1518.717,-273.7767;Inherit;False;0;2;2;0.6320754,0,0,0;1,0.9427806,0.1273585,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;49.02504,127.728;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;117;-233.0432,-159.2381;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;216.8149,211.2551;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-1185.845,-541.1329;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;15;920.6619,226.1416;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_lava_flow;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;594.3677,422.1728;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;144;294.0676,517.0728;Inherit;False;ase_function_heightFog;1;;1;eac3be27823c065409c0c16e1b3abe29;0;1;16;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;129;-1500.584,-472.6253;Inherit;False;Property;_Color2;Color 2;18;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;6.943396,3.845344,0.2947667,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;100;0;101;0
WireConnection;100;1;103;0
WireConnection;101;0;102;0
WireConnection;101;1;109;0
WireConnection;103;0;105;0
WireConnection;103;1;104;0
WireConnection;104;0;106;0
WireConnection;105;1;104;0
WireConnection;26;0;94;0
WireConnection;26;1;95;0
WireConnection;94;0;90;0
WireConnection;94;1;108;0
WireConnection;95;0;96;0
WireConnection;95;1;58;0
WireConnection;96;1;58;0
WireConnection;58;0;97;0
WireConnection;120;0;125;0
WireConnection;120;1;126;0
WireConnection;121;0;122;0
WireConnection;121;1;124;0
WireConnection;124;0;123;0
WireConnection;122;1;124;0
WireConnection;119;0;120;0
WireConnection;119;1;121;0
WireConnection;98;1;100;0
WireConnection;9;1;26;0
WireConnection;132;0;114;2
WireConnection;131;0;130;0
WireConnection;131;1;136;0
WireConnection;134;0;131;0
WireConnection;134;1;133;0
WireConnection;136;0;132;0
WireConnection;116;1;119;0
WireConnection;130;0;116;1
WireConnection;133;0;131;0
WireConnection;135;0;134;0
WireConnection;107;0;117;0
WireConnection;107;1;98;0
WireConnection;117;0;128;0
WireConnection;117;1;9;0
WireConnection;117;2;135;0
WireConnection;110;0;107;0
WireConnection;110;1;111;0
WireConnection;128;0;116;1
WireConnection;128;1;129;0
WireConnection;15;2;145;0
WireConnection;145;0;110;0
WireConnection;145;1;144;0
ASEEND*/
//CHKSM=DE1CC1DE24C57B12ADC2BA998B0A3324794B1709