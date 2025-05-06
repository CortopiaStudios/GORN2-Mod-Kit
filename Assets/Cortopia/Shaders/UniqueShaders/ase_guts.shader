// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_guts"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "white" {}
		_Normalmap("Normalmap", 2D) = "bump" {}
		_VertexAnim("VertexAnim", Range( 0 , 1)) = 0.5
		_VertexOffsetScale("VertexOffsetScale", Range( 0 , 0.1)) = 0.03
		_NoiseScale("NoiseScale", Float) = 3
		[Toggle(_ISSIMPLESHADER_ON)] _IsSimpleShader("IsSimpleShader", Float) = 0
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred nodynlightmap nofog noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VertexAnim;
		uniform float _NoiseScale;
		uniform float _VertexOffsetScale;
		uniform sampler2D _Normalmap;
		uniform float4 _Normalmap_ST;
		uniform sampler2D _Albedo_Smoothness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime6 = _Time.y * 0.15;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_20_0 = ( ( mulTime6 * _VertexAnim ) + ase_vertexNormal );
			float simplePerlin2D28 = snoise( temp_output_20_0.xy*_NoiseScale );
			simplePerlin2D28 = simplePerlin2D28*0.5 + 0.5;
			float3 temp_cast_1 = ((( -1.0 * _VertexOffsetScale ) + (simplePerlin2D28 - 0.0) * (_VertexOffsetScale - ( -1.0 * _VertexOffsetScale )) / (1.0 - 0.0))).xxx;
			v.vertex.xyz += temp_cast_1;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			#ifdef _ISSIMPLESHADER_ON
				float3 staticSwitch31 = float3(0,0,1);
			#else
				float3 staticSwitch31 = UnpackNormal( tex2D( _Normalmap, uv_Normalmap ) );
			#endif
			o.Normal = staticSwitch31;
			float mulTime6 = _Time.y * 0.15;
			float4 appendResult8 = (float4(mulTime6 , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord5 = i.uv_texcoord + appendResult8.xy;
			float4 tex2DNode3 = tex2D( _Albedo_Smoothness, uv_TexCoord5 );
			o.Albedo = tex2DNode3.rgb;
			o.Smoothness = tex2DNode3.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;691,-220;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_guts;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-823,-142.5;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;22;378,115.5;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;66,245.5;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-453,99.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;25;-240,-11.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;c1bd733b8c37d8e4e986dd51b2f0e1fe;True;0;False;white;Auto;False;Instance;3;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;28;-229,184.5;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-218,414.5;Inherit;False;Property;_VertexOffsetScale;VertexOffsetScale;3;0;Create;True;0;0;0;False;0;False;0.03;0.0322;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;19;-718,216.5;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-679,98.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-480,271.5;Inherit;False;Property;_NoiseScale;NoiseScale;4;0;Create;True;0;0;0;False;0;False;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;31;252.4,-414.0999;Inherit;False;Property;_IsSimpleShader;IsSimpleShader;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;32;-2.399902,-390.9;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-107,-603.5;Inherit;True;Property;_Normalmap;Normalmap;1;0;Create;True;0;0;0;False;0;False;-1;None;d9e36e76eef00d046823e55f6e51e65b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-423,-196.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-101,-221.5;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;c1bd733b8c37d8e4e986dd51b2f0e1fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1063,121.5;Inherit;False;Property;_VertexAnim;VertexAnim;2;0;Create;True;0;0;0;False;0;False;0.5;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1191,-147.5;Inherit;False;1;0;FLOAT;0.15;False;1;FLOAT;0
WireConnection;0;0;3;0
WireConnection;0;1;31;0
WireConnection;0;4;3;4
WireConnection;0;11;22;0
WireConnection;8;0;6;0
WireConnection;22;0;28;0
WireConnection;22;3;23;0
WireConnection;22;4;24;0
WireConnection;23;1;24;0
WireConnection;20;0;17;0
WireConnection;20;1;19;0
WireConnection;25;1;20;0
WireConnection;28;0;20;0
WireConnection;28;1;29;0
WireConnection;17;0;6;0
WireConnection;17;1;18;0
WireConnection;31;1;4;0
WireConnection;31;0;32;0
WireConnection;5;1;8;0
WireConnection;3;1;5;0
ASEEND*/
//CHKSM=083070D709F77EEC7F53AF775FFF3D3536CAA531