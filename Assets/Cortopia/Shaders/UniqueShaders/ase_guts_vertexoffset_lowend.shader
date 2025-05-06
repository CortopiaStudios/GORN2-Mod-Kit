// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_guts_vertexoffset_lowend"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "white" {}
		_OffsetMask("Offset Mask", 2D) = "black" {}
		_Speed("Speed", Range( 0 , 10)) = 0
		_BulgeWidth("Bulge Width", Range( 0 , 100)) = 94.46826
		_BulgePower("Bulge Power", Range( 0 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _OffsetMask;
		uniform float _Speed;
		uniform float _BulgeWidth;
		uniform float _BulgePower;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime40 = _Time.y * (0.0 + (_Speed - 0.0) * (1.0 - 0.0) / (10.0 - 0.0));
			float4 appendResult41 = (float4(mulTime40 , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord39 = v.texcoord.xy + appendResult41.xy;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( saturate( ( ( 1.0 - ( tex2Dlod( _OffsetMask, float4( uv_TexCoord39, 0, 0.0) ) * (0.0 + (_BulgeWidth - 100.0) * (100.0 - 0.0) / (0.0 - 100.0)) ) ) * _BulgePower ) ) * float4( ase_vertexNormal , 0.0 ) ) * ( 1.0 - v.color.g ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode15 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			o.Albedo = tex2DNode15.rgb;
			o.Smoothness = tex2DNode15.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-874.1565,256.9022;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;31;-645.6947,262.7784;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;34;-659.3047,586.102;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;29;-662.6414,371.2299;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-451.2621,286.0318;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-216.2763,282.0009;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;-472.8002,594.6719;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;107.5255,-6.413731;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_guts_vertexoffset_lowend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1175.503,529.415;Inherit;False;Property;_BulgePower;Bulge Power;4;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1091.803,255.6099;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1343.725,258.1116;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1576.022,332.7157;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;100;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1885.479,343.214;Inherit;False;Property;_BulgeWidth;Bulge Width;3;0;Create;True;0;0;0;False;0;False;94.46826;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-1978.078,131.7575;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1684.699,119.8107;Inherit;True;Property;_OffsetMask;Offset Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;c1bd733b8c37d8e4e986dd51b2f0e1fe;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;40;-2348.893,138.713;Inherit;False;1;0;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-2538.032,140.7439;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2830.864,142.8639;Inherit;True;Property;_Speed;Speed;2;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2158.475,137.0514;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;15;-699.48,-11.66685;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;c1bd733b8c37d8e4e986dd51b2f0e1fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;31;0;26;0
WireConnection;30;0;31;0
WireConnection;30;1;29;0
WireConnection;36;0;30;0
WireConnection;36;1;35;0
WireConnection;35;0;34;2
WireConnection;0;0;15;0
WireConnection;0;4;15;4
WireConnection;0;11;36;0
WireConnection;24;0;22;0
WireConnection;22;0;18;0
WireConnection;22;1;33;0
WireConnection;33;0;25;0
WireConnection;39;1;41;0
WireConnection;18;1;39;0
WireConnection;40;0;42;0
WireConnection;42;0;38;0
WireConnection;41;0;40;0
ASEEND*/
//CHKSM=72836E550196683730B71D8B8665FC3B583116BD