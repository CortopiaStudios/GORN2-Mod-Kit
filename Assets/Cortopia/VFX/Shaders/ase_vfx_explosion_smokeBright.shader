// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_explosion_smokeBright"
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
				float fresnelNode480 = ( 0.06 + 4.51 * pow( 1.0 - fresnelNdotV480, 1.77 ) );
				float smoothstepResult486 = smoothstep( 0.73 , 1.83 , fresnelNode480);
				float4 lerpResult485 = lerp( ( _ColorLight2 * ( 1.0 - smoothstepResult486 ) * ( 1.0 - i.ase_color.r ) ) , float4( 0,0,0,0 ) , i.ase_color.a);
				float4 temp_output_412_0 = saturate( _ColorSmoke );
				float4 lerpResult414 = lerp( temp_output_412_0 , ( ( temp_output_412_0 + _ColorLight ) * _Boost ) , saturate( i.ase_color.b ));
				Gradient gradient458 = NewGradient( 0, 4, 2, float4( 1, 0.7490566, 0.4386792, 0.002792401 ), float4( 1, 0.9851752, 0.9481132, 0.2203403 ), float4( 0.3207547, 0, 0.02138363, 0.8784009 ), float4( 0, 0, 0, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				
				
				finalColor = CalculateContrast(_Contrast,( ( lerpResult485 + lerpResult414 ) + ( SampleGradient( gradient458, i.ase_color.a ) * _Boost ) ));
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;1344.804,1853.3;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;422;568.9277,2442.887;Inherit;False;Property;_Spikes;Spikes;0;0;Create;True;0;0;0;False;0;False;0.7133961;1.25;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;423;594.9769,1855.552;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;427;731.9165,2218.267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;426;903.6857,2241.701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;424;1118.213,2036.05;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;403;855.311,1314.959;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;2741.721,990.8029;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;435;935.781,1695.771;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;221;731.4692,927.6042;Inherit;False;Property;_ColorLight;ColorLight;1;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;3.245283,0.3907933,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;481;2764.118,230.856;Inherit;False;Property;_ColorLight2;ColorLight2;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;3.245283,0.3907933,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;414;3058.994,988.5419;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;484;2908.719,752.6765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;482;3143.431,461.3788;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;487;2839.562,549.3969;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;485;3281.747,704.4761;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;483;3713.456,855.364;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;490;2290.497,360.7871;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;489;1902.8,98.82916;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.58;False;2;FLOAT;38.8;False;3;FLOAT;10.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;447;1484.248,1584.828;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;453;2345.093,1253.432;Inherit;False;Property;_Boost;Boost;4;0;Create;True;0;0;0;False;0;False;0;2.61;1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;404;1392.935,1005.994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;492;2905.294,1520.455;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;493;2336.603,595.5015;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;480;1936.328,375.4571;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.06;False;2;FLOAT;4.51;False;3;FLOAT;1.77;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;474;1024.751,67.91654;Inherit;False;Property;_ColorSmoke;ColorSmoke;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;0.003921569,0.003921569,0.003921569,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;412;1754.129,841.6324;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;494;2134.089,757.6333;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;495;2909.484,914.808;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;451;3551.895,1694.614;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;475;4031.436,1481.578;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;449;3955.514,1686.176;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;3788.899,1557.411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;456;3412.424,1356.991;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.26;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;442;2993.091,1523.375;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;488;1718.382,1389.758;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;408;2051.79,863.2565;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;486;2479.106,561.971;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;1.83;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;4580.243,1982.295;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_explosion_smokeBright;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;498;4440.647,1632.855;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;499;4165.299,1836.885;Inherit;False;Property;_Contrast;Contrast;5;0;Create;True;0;0;0;False;0;False;1;1.046;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;458;3038.896,1318.25;Inherit;False;0;4;2;1,0.7490566,0.4386792,0.002792401;1,0.9851752,0.9481132,0.2203403;0.3207547,0,0.02138363,0.8784009;0,0,0,1;1,0;1,1;0;1;OBJECT;0
WireConnection;421;0;435;0
WireConnection;421;1;424;0
WireConnection;427;0;423;2
WireConnection;426;0;427;0
WireConnection;426;1;422;0
WireConnection;424;0;423;2
WireConnection;424;4;426;0
WireConnection;452;0;408;0
WireConnection;452;1;453;0
WireConnection;414;0;495;0
WireConnection;414;1;452;0
WireConnection;414;2;492;0
WireConnection;484;0;403;1
WireConnection;482;0;481;0
WireConnection;482;1;487;0
WireConnection;482;2;484;0
WireConnection;487;0;486;0
WireConnection;485;0;482;0
WireConnection;485;2;403;4
WireConnection;483;0;485;0
WireConnection;483;1;414;0
WireConnection;490;0;480;0
WireConnection;490;1;489;0
WireConnection;447;0;403;3
WireConnection;404;1;403;1
WireConnection;492;0;447;0
WireConnection;412;0;474;0
WireConnection;494;0;412;0
WireConnection;495;0;494;0
WireConnection;451;0;442;2
WireConnection;475;0;483;0
WireConnection;475;1;491;0
WireConnection;449;1;451;0
WireConnection;491;0;456;0
WireConnection;491;1;453;0
WireConnection;456;0;458;0
WireConnection;456;1;442;4
WireConnection;488;0;403;4
WireConnection;408;0;412;0
WireConnection;408;1;221;0
WireConnection;486;0;480;0
WireConnection;257;0;498;0
WireConnection;257;1;421;0
WireConnection;498;1;475;0
WireConnection;498;0;499;0
ASEEND*/
//CHKSM=13107A3AD214DDB8811A3DCEEA1068D7C736740E