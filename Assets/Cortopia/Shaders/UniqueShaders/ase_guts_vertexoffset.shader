// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_guts_vertexoffset"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "white" {}
		_OffsetMask("Offset Mask", 2D) = "black" {}
		_Normalmap("Normalmap", 2D) = "bump" {}
		_Speed("Speed", Range( 0 , 10)) = 0
		_BulgeWidth("Bulge Width", Range( 0 , 100)) = 94.46826
		[Toggle(_ISSIMPLESHADER_ON)] _IsSimpleShader("IsSimpleShader", Float) = 0
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
		#pragma shader_feature_local _ISSIMPLESHADER_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _OffsetMask;
		uniform float _Speed;
		uniform float _BulgeWidth;
		uniform float _BulgePower;
		uniform sampler2D _Normalmap;
		uniform float4 _Normalmap_ST;
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
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			#ifdef _ISSIMPLESHADER_ON
				float3 staticSwitch11 = float3(0,0,1);
			#else
				float3 staticSwitch11 = UnpackNormal( tex2D( _Normalmap, uv_Normalmap ) );
			#endif
			o.Normal = staticSwitch11;
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
Node;AmplifyShaderEditor.StaticSwitch;11;-351.4027,-196.5818;Inherit;False;Property;_IsSimpleShader;IsSimpleShader;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;12;-606.202,-174.3818;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;13;-710.8018,-385.9818;Inherit;True;Property;_Normalmap;Normalmap;2;0;Create;True;0;0;0;False;0;False;-1;None;d9e36e76eef00d046823e55f6e51e65b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-874.1565,256.9022;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;31;-645.6947,262.7784;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;34;-659.3047,586.102;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;29;-662.6414,371.2299;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-451.2621,286.0318;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-216.2763,282.0009;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;-472.8002,594.6719;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;107.5255,-6.413731;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_guts_vertexoffset;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1175.503,529.415;Inherit;False;Property;_BulgePower;Bulge Power;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1091.803,255.6099;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1343.725,258.1116;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1576.022,332.7157;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;100;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1885.479,343.214;Inherit;False;Property;_BulgeWidth;Bulge Width;4;0;Create;True;0;0;0;False;0;False;94.46826;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-1978.078,131.7575;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1684.699,119.8107;Inherit;True;Property;_OffsetMask;Offset Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;c1bd733b8c37d8e4e986dd51b2f0e1fe;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;40;-2348.893,138.713;Inherit;False;1;0;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-2538.032,140.7439;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2830.864,142.8639;Inherit;True;Property;_Speed;Speed;3;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2158.475,137.0514;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;15;-699.48,-11.66685;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;c1bd733b8c37d8e4e986dd51b2f0e1fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;11;1;13;0
WireConnection;11;0;12;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;31;0;26;0
WireConnection;30;0;31;0
WireConnection;30;1;29;0
WireConnection;36;0;30;0
WireConnection;36;1;35;0
WireConnection;35;0;34;2
WireConnection;0;0;15;0
WireConnection;0;1;11;0
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
//CHKSM=B7218B669CD3725E30099D16D5FE859633002D88