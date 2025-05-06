// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AsePaintableArmor"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Cracks("Cracks", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
		_Cracks_Normal("Cracks_Normal", 2D) = "bump" {}
		_Color0("Color 0", Color) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Cracks_Normal;
		uniform sampler2D _MaskTexture;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Color0;
		uniform sampler2D _Cracks;


		float2 voronoihash41( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi41( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash41( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode21 = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), 1.0 );
			float2 uv_TexCoord51 = i.uv_texcoord * float2( 10,10 );
			float4 tex2DNode2 = tex2D( _MaskTexture, i.uv_texcoord );
			float3 lerpResult50 = lerp( tex2DNode21 , BlendNormals( tex2DNode21 , UnpackScaleNormal( tex2D( _Cracks_Normal, uv_TexCoord51 ), 1.0 ) ) , tex2DNode2.g);
			o.Normal = lerpResult50;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float time41 = 0.0;
			float2 voronoiSmoothId41 = 0;
			float2 coords41 = i.uv_texcoord * 30.0;
			float2 id41 = 0;
			float2 uv41 = 0;
			float voroi41 = voronoi41( coords41, time41, id41, uv41, 0, voronoiSmoothId41 );
			float4 lerpResult47 = lerp( tex2DNode1 , _Color0 , step( 0.3 , ( tex2DNode2.r + ( tex2DNode2.r * ( voroi41 * 2.0 ) ) ) ));
			float4 tex2DNode26 = tex2D( _Cracks, uv_TexCoord51 );
			float4 lerpResult3 = lerp( lerpResult47 , ( lerpResult47 * tex2DNode26 ) , tex2DNode2.g);
			o.Albedo = lerpResult3.rgb;
			float lerpResult49 = lerp( tex2DNode1.a , ( tex2DNode1.a * tex2DNode26.a ) , tex2DNode2.g);
			o.Smoothness = saturate( lerpResult49 );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SamplerNode;31;234.166,473.4067;Inherit;True;Property;_Cracks_Normal;Cracks_Normal;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;32;584.4664,440.5518;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;21;244.8464,285.6911;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;67.58862,379.6044;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1211.694,-238.5315;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AsePaintableArmor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;50;825.4639,290.5514;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;23;866.1097,20.89369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-508.4214,-383.0055;Inherit;True;Property;_Cracks;Cracks;1;0;Create;True;0;0;0;False;0;False;-1;None;ed6c812fefc816740984fa70b2cefd55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-523.3731,-756.825;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;ed6c812fefc816740984fa70b2cefd55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;-495.086,-567.9644;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-806.3333,297.2788;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-961.5394,315.3194;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;41;-1181.618,264.9762;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;30;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StepOpNode;46;-305.0392,191.0867;Inherit;True;2;0;FLOAT;0.3;False;1;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-557.6921,253.9379;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;103.9827,-515.7368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1506.246,13.83673;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1135.151,-209.9801;Inherit;True;Property;_MaskTexture;MaskTexture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-810.8855,44.12714;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;73.38828,-68.38809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;374.9955,22.51094;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;678.4293,78.20816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;491.1689,163.7632;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;856.8254,-287.9094;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;392.5909,-299.3584;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;31;1;51;0
WireConnection;31;5;35;0
WireConnection;32;0;21;0
WireConnection;32;1;31;0
WireConnection;21;5;35;0
WireConnection;0;0;3;0
WireConnection;0;1;50;0
WireConnection;0;4;23;0
WireConnection;50;0;21;0
WireConnection;50;1;32;0
WireConnection;50;2;2;2
WireConnection;23;0;49;0
WireConnection;26;1;51;0
WireConnection;43;0;2;1
WireConnection;43;1;42;0
WireConnection;42;0;41;0
WireConnection;41;0;9;0
WireConnection;46;1;45;0
WireConnection;45;0;2;1
WireConnection;45;1;43;0
WireConnection;47;0;1;0
WireConnection;47;1;48;0
WireConnection;47;2;46;0
WireConnection;2;1;9;0
WireConnection;22;0;1;4
WireConnection;22;1;26;4
WireConnection;49;0;1;4
WireConnection;49;1;22;0
WireConnection;49;2;2;2
WireConnection;33;1;24;0
WireConnection;3;0;47;0
WireConnection;3;1;29;0
WireConnection;3;2;2;2
WireConnection;29;0;47;0
WireConnection;29;1;26;0
ASEEND*/
//CHKSM=76061F36F14896B2AAC1D3CB7B0D0350330427D7