// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AsePaintableWeapon"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _MaskTexture;


		float2 voronoihash15( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi15( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash15( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode2 = tex2D( _MaskTexture, i.uv_texcoord );
			float time15 = 0.0;
			float2 voronoiSmoothId15 = 0;
			float2 coords15 = i.uv_texcoord * 30.0;
			float2 id15 = 0;
			float2 uv15 = 0;
			float voroi15 = voronoi15( coords15, time15, id15, uv15, 0, voronoiSmoothId15 );
			float4 lerpResult3 = lerp( tex2D( _TextureSample0, uv_TextureSample0 ) , tex2DNode2 , step( ( 1.0 - tex2DNode2.a ) , ( tex2DNode2.a + ( tex2DNode2.a * ( voroi15 * 2.0 ) ) ) ));
			o.Emission = lerpResult3.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-553.5,217.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-174.5,-434.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;ed6c812fefc816740984fa70b2cefd55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-924.5,-188.5;Inherit;True;Property;_MaskTexture;MaskTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;618,-246;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AsePaintableWeapon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;3;245.5,-207.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-82.57375,-109.6044;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.09710693,1,0,0;0.09710693,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-303.5,177.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-823.75,67.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;4;-72.5,55.5;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-414.5,-87.5;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-257.75,67.5;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-1373.2,445.2003;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1017.951,405.4007;Inherit;True;Property;_NoiseCube;NoiseCube;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1663.004,-190.2002;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;15;-1150.75,58.5;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;30;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
WireConnection;7;0;2;4
WireConnection;7;1;18;0
WireConnection;2;1;9;0
WireConnection;0;2;3;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;4;0
WireConnection;8;0;2;4
WireConnection;8;1;7;0
WireConnection;18;0;15;0
WireConnection;4;0;10;0
WireConnection;4;1;8;0
WireConnection;10;0;2;4
WireConnection;6;0;9;0
WireConnection;15;0;9;0
ASEEND*/
//CHKSM=AFB0A2A15900FB4B9CB4E06AF87123C12362CE80