// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_explosion_smoke"
{
	Properties
	{
		_Spikes("Spikes", Range( 0 , 10)) = 0.7133961
		[HDR]_ColorLight("ColorLight", Color) = (1,0.4536018,0,1)
		[HDR]_ColorLight2("ColorLight2", Color) = (1,0.4536018,0,1)
		[HDR]_ColorSmoke("ColorSmoke", Color) = (1,0.4536018,0,1)
		_Boost("Boost", Range( 1 , 3)) = 0
		_Contrast("Contrast", Range( 0 , 2)) = 1

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
		ColorMask RGB
		ZWrite Off
		ZTest LEqual
		
		
		
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
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
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

			uniform float _Spikes;
			uniform float _Contrast;
			uniform float4 _ColorLight2;
			uniform float4 _ColorSmoke;
			uniform float4 _ColorLight;
			uniform float _Boost;
			struct Gradient
			{
				int type;
				int colorsLength;
				int alphasLength;
				float4 colors[8];
				float2 alphas[8];
			};
			
			Gradient NewGradient(int type, int colorsLength, int alphasLength, 
			float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
			float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
			{
				Gradient g;
				g.type = type;
				g.colorsLength = colorsLength;
				g.alphasLength = alphasLength;
				g.colors[ 0 ] = colors0;
				g.colors[ 1 ] = colors1;
				g.colors[ 2 ] = colors2;
				g.colors[ 3 ] = colors3;
				g.colors[ 4 ] = colors4;
				g.colors[ 5 ] = colors5;
				g.colors[ 6 ] = colors6;
				g.colors[ 7 ] = colors7;
				g.alphas[ 0 ] = alphas0;
				g.alphas[ 1 ] = alphas1;
				g.alphas[ 2 ] = alphas2;
				g.alphas[ 3 ] = alphas3;
				g.alphas[ 4 ] = alphas4;
				g.alphas[ 5 ] = alphas5;
				g.alphas[ 6 ] = alphas6;
				g.alphas[ 7 ] = alphas7;
				return g;
			}
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( v.ase_normal * (0.0 + (v.color.g - 0.0) * (( ( 1.0 - v.color.g ) * _Spikes ) - 0.0) / (1.0 - 0.0)) );
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
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV480 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode480 = ( 0.0 + 2.17 * pow( 1.0 - fresnelNdotV480, 1.12 ) );
				float smoothstepResult486 = smoothstep( 0.8 , 1.0 , fresnelNode480);
				float temp_output_506_0 = saturate( smoothstepResult486 );
				float4 temp_output_482_0 = ( _ColorLight2 * ( 1.0 - temp_output_506_0 ) );
				float4 lerpResult414 = lerp( float4( 0,0,0,0 ) , ( ( saturate( _ColorSmoke ) + _ColorLight ) * _Boost ) , i.ase_color.b);
				float4 lerpResult485 = lerp( temp_output_482_0 , lerpResult414 , i.ase_color.a);
				Gradient gradient458 = NewGradient( 0, 5, 2, float4( 1, 0.7490566, 0.4386792, 0.002792401 ), float4( 1, 0.9851752, 0.9481132, 0.07547113 ), float4( 0.9339623, 0, 0.04169436, 0.3721676 ), float4( 0.6698113, 0, 0.03189566, 0.5254292 ), float4( 0.01886791, 0.01886791, 0.01886791, 0.995758 ), 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float4 smoke532 = _ColorSmoke;
				
				
				finalColor = saturate( ( CalculateContrast(_Contrast,( ( lerpResult485 + lerpResult414 ) + ( SampleGradient( gradient458, i.ase_color.a ) * _Boost ) )) + ( temp_output_506_0 * smoke532 ) ) );
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
Node;AmplifyShaderEditor.RangedFloatNode;422;568.9277,2442.887;Inherit;False;Property;_Spikes;Spikes;0;0;Create;True;0;0;0;False;0;False;0.7133961;0.74;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;423;594.9769,1855.552;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;427;731.9165,2218.267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;435;935.781,1695.771;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;481;2764.118,230.856;Inherit;False;Property;_ColorLight2;ColorLight2;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;6.422234,3.113757,0.3332292,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;447;1484.248,1584.828;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;474;1024.751,67.91654;Inherit;False;Property;_ColorSmoke;ColorSmoke;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;0.7830189,0.7830189,0.7830189,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;426;932.5961,2241.701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;424;1100.422,1935.975;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;1469.341,1713.196;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;504;1331.531,2250.839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;505;1567.262,2061.81;Inherit;False;2;2;0;FLOAT;0.95;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;221;1689.208,1399.128;Inherit;False;Property;_ColorLight;ColorLight;1;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;8.474188,0.9471292,0.5196438,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;403;790.6783,1253.265;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;408;2049.121,1333.434;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;412;1694.928,761.0583;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;512;1611.886,191.4189;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;513;1632.45,231.0799;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;2738.784,1318.371;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;453;2370.067,1689.701;Inherit;False;Property;_Boost;Boost;4;0;Create;True;0;0;0;False;0;False;0;3;1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;482;3042.075,459.9099;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;507;3433.582,373.9767;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;442;3053.317,1372.077;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;458;3058.342,1235.649;Inherit;False;0;5;2;1,0.7490566,0.4386792,0.002792401;1,0.9851752,0.9481132,0.07547113;0.9339623,0,0.04169436,0.3721676;0.6698113,0,0.03189566,0.5254292;0.01886791,0.01886791,0.01886791,0.995758;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;5463.305,2292.713;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_explosion_smoke;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;532;1341.512,34.3559;Inherit;False;smoke;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;3765.965,1648.484;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;539;5108.588,1970.876;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;480;1815.118,368.5308;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2.17;False;3;FLOAT;1.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;542;2176.993,653.5117;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;543;3705.954,1377.303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;486;2160.562,364.8043;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;545;2379.581,660.438;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;499;3915.06,1243.21;Inherit;False;Property;_Contrast;Contrast;5;0;Create;True;0;0;0;False;0;False;1;1.441;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;546;4341.436,1375.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;544;2571.249,698.7753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;483;4123.673,1004.665;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;456;3336.415,1348.521;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.26;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;498;4521.007,1130.601;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;519;4512.028,1589.288;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;487;2594.082,446.088;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;506;2392.862,358.1512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;547;4306.748,1862.214;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;548;3977.635,1921.129;Inherit;False;532;smoke;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;549;4774.007,1837.836;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;550;4861.363,1362.451;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;485;3302.946,728.3417;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;414;2967.573,1055.584;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
WireConnection;427;0;423;2
WireConnection;447;0;403;3
WireConnection;426;0;427;0
WireConnection;426;1;422;0
WireConnection;424;0;423;2
WireConnection;424;4;426;0
WireConnection;421;0;435;0
WireConnection;421;1;424;0
WireConnection;504;0;423;4
WireConnection;505;1;504;0
WireConnection;408;0;412;0
WireConnection;408;1;221;0
WireConnection;412;0;513;0
WireConnection;512;0;474;0
WireConnection;513;0;512;0
WireConnection;452;0;408;0
WireConnection;452;1;453;0
WireConnection;482;0;481;0
WireConnection;482;1;487;0
WireConnection;507;0;482;0
WireConnection;257;0;539;0
WireConnection;257;1;421;0
WireConnection;532;0;474;0
WireConnection;491;0;456;0
WireConnection;491;1;453;0
WireConnection;539;0;549;0
WireConnection;542;0;480;0
WireConnection;486;0;480;0
WireConnection;545;0;542;0
WireConnection;546;0;499;0
WireConnection;546;1;544;0
WireConnection;544;0;545;0
WireConnection;483;0;485;0
WireConnection;483;1;414;0
WireConnection;456;0;458;0
WireConnection;456;1;442;4
WireConnection;498;1;519;0
WireConnection;498;0;499;0
WireConnection;519;0;483;0
WireConnection;519;1;491;0
WireConnection;487;0;506;0
WireConnection;506;0;486;0
WireConnection;547;0;506;0
WireConnection;547;1;548;0
WireConnection;549;0;498;0
WireConnection;549;1;547;0
WireConnection;485;0;482;0
WireConnection;485;1;414;0
WireConnection;485;2;403;4
WireConnection;414;1;452;0
WireConnection;414;2;403;3
ASEEND*/
//CHKSM=C32D9F4568DBE268D17C8BA5BF7AEFEBA02E51B2