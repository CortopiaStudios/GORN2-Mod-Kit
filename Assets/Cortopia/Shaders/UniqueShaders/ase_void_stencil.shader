// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_void_stencil"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_TextureSpeed("Texture Speed", Float) = 0
		_NoiseSpeed("Noise Speed", Float) = 0
		[HDR]_BeamColor("Beam Color", Color) = (0,0,0,0)
		_NoisePower("Noise Power", Float) = 0
		_NoiseAmount("Noise Amount", Range( 0 , 1)) = 0.5
		_NoiseScale("Noise Scale", Float) = 1
		[Toggle(_USETEXTUREALPHA_ON)] _UseTextureAlpha("UseTextureAlpha", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _USETEXTUREALPHA_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _BeamColor;
			uniform sampler2D _MainTexture;
			uniform float _TextureSpeed;
			uniform float4 _MainTexture_ST;
			uniform float _NoiseSpeed;
			uniform float _NoiseScale;
			uniform float _NoisePower;
			uniform float _NoiseAmount;
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 appendResult10 = (float2(_TextureSpeed , 0.0));
				float2 uv_MainTexture = i.ase_texcoord1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float2 panner12 = ( _Time.y * appendResult10 + uv_MainTexture);
				float2 appendResult3 = (float2(_NoiseSpeed , 0.0));
				float2 panner6 = ( _Time.y * appendResult3 + uv_MainTexture);
				float simplePerlin2D11 = snoise( panner6*_NoiseScale );
				simplePerlin2D11 = simplePerlin2D11*0.5 + 0.5;
				float2 temp_cast_0 = (pow( simplePerlin2D11 , _NoisePower )).xx;
				float2 lerpResult15 = lerp( panner12 , temp_cast_0 , _NoiseAmount);
				float4 tex2DNode32 = tex2D( _MainTexture, lerpResult15 );
				#ifdef _USETEXTUREALPHA_ON
				float staticSwitch39 = tex2DNode32.a;
				#else
				float staticSwitch39 = 1.0;
				#endif
				float4 appendResult36 = (float4(( ( _BeamColor * tex2DNode32 ) * i.ase_color ).rgb , ( i.ase_color.a * staticSwitch39 * _BeamColor.a )));
				
				
				finalColor = appendResult36;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;1;-2506.296,-121.9483;Inherit;False;1429;545;UV Animation;14;15;14;13;12;11;10;9;8;7;6;4;3;2;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2456.296,283.0517;Inherit;False;Property;_NoiseSpeed;Noise Speed;2;0;Create;True;0;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-2302.296,195.0518;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2344.924,45.72028;Inherit;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;3;-2264.296,288.0517;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2455.297,-71.94829;Inherit;False;Property;_TextureSpeed;Texture Speed;1;0;Create;True;0;0;0;False;0;False;0;-0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1996.17,265.8761;Inherit;False;Property;_NoiseScale;Noise Scale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-2039.296,137.0517;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1719.296,253.0517;Inherit;False;Property;_NoisePower;Noise Power;4;0;Create;True;0;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-2265.296,-65.94828;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;11;-1770.17,65.8761;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-1528.296,69.0517;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1529.296,167.0517;Inherit;False;Property;_NoiseAmount;Noise Amount;5;0;Create;True;0;0;0;False;0;False;0.5;0.658;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-2040.296,2.051735;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;15;-1259.297,4.051735;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-861.2668,195.8318;Inherit;False;Constant;_ConstOne;ConstOne;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;40;-588.0311,-32.39598;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-462.0311,-144.396;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;39;-706.2668,150.8318;Inherit;False;Property;_UseTextureAlpha;UseTextureAlpha;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-245.0311,52.60404;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-244.0311,-144.396;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;79.73355,-11.16814;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;37;-753.0311,-254.3959;Inherit;False;Property;_BeamColor;Beam Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.8156863,0.4392157,1.019608,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;46;268.9,-16.7;Float;False;True;-1;2;ASEMaterialInspector;100;5;ase_void_stencil;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SamplerNode;32;-1034.361,-22.03326;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;3;0;2;0
WireConnection;6;0;31;0
WireConnection;6;2;3;0
WireConnection;6;1;4;0
WireConnection;10;0;7;0
WireConnection;11;0;6;0
WireConnection;11;1;8;0
WireConnection;13;0;11;0
WireConnection;13;1;9;0
WireConnection;12;0;31;0
WireConnection;12;2;10;0
WireConnection;12;1;4;0
WireConnection;15;0;12;0
WireConnection;15;1;13;0
WireConnection;15;2;14;0
WireConnection;33;0;37;0
WireConnection;33;1;32;0
WireConnection;39;1;38;0
WireConnection;39;0;32;4
WireConnection;34;0;40;4
WireConnection;34;1;39;0
WireConnection;34;2;37;4
WireConnection;35;0;33;0
WireConnection;35;1;40;0
WireConnection;36;0;35;0
WireConnection;36;3;34;0
WireConnection;46;0;36;0
WireConnection;32;1;15;0
ASEEND*/
//CHKSM=F53B8C88D38331278C66D216559A654E9506E73F