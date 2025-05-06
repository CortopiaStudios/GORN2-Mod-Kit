// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AsePaintableArena"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_FreshBlood("FreshBlood", Color) = (1,0,0,0)
		_DryBlood("DryBlood", Color) = (0.735849,0.06534614,0,0)
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
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 vertexToFrag10_g1;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _DryBlood;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform float4 _FreshBlood;


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
			o.vertexToFrag10_g1 = ( ( v.texcoord1.xy * (unity_LightmapST).xy ) + (unity_LightmapST).zw );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _MaskTexture, uv_MaskTexture );
			float simplePerlin2D6 = snoise( i.uv_texcoord*40.0 );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float4 lerpResult3 = lerp( tex2D( _TextureSample0, uv_TextureSample0 ) , ( ( _DryBlood * tex2DNode2.r ) + ( tex2DNode2.a * _FreshBlood ) ) , step( 0.5 , ( tex2DNode2.r + ( tex2DNode2.r * simplePerlin2D6 ) ) ));
			float4 tex2DNode7_g1 = UNITY_SAMPLE_TEX2D( unity_Lightmap, i.vertexToFrag10_g1 );
			float3 decodeLightMap6_g1 = DecodeLightmap(tex2DNode7_g1);
			o.Emission = ( lerpResult3 * float4( decodeLightMap6_g1 , 0.0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1057.5,240.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-826.5,235.5;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-924.5,-188.5;Inherit;True;Property;_MaskTexture;MaskTexture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;677.25,-177.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;12;438.25,30.5;Inherit;False;FetchLightmapValue;1;;1;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;3;481.5,-186.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;88.5,-521.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;ed6c812fefc816740984fa70b2cefd55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;225.4388,-178.2486;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-553.5,217.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-322.5,193.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;4;-113.5,170.5;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-103.161,-128.7875;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-101.5612,-225.2486;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-396.161,-345.7875;Inherit;False;Property;_DryBlood;DryBlood;5;0;Create;True;0;0;0;False;0;False;0.735849,0.06534614,0,0;0.09710693,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-388.5738,-28.6044;Inherit;False;Property;_FreshBlood;FreshBlood;4;0;Create;True;0;0;0;False;0;False;1,0,0,0;0.09710693,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;854,-225;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AsePaintableArena;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;9;0
WireConnection;11;0;3;0
WireConnection;11;1;12;0
WireConnection;3;0;1;0
WireConnection;3;1;20;0
WireConnection;3;2;4;0
WireConnection;20;0;21;0
WireConnection;20;1;14;0
WireConnection;7;0;2;1
WireConnection;7;1;6;0
WireConnection;8;0;2;1
WireConnection;8;1;7;0
WireConnection;4;1;8;0
WireConnection;14;0;2;4
WireConnection;14;1;13;0
WireConnection;21;0;16;0
WireConnection;21;1;2;1
WireConnection;0;2;11;0
ASEEND*/
//CHKSM=FCD0991E14391923C83A36FCACDEB88F3686F408