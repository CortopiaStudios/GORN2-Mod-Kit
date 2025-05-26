// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_powerup_backshine"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,0.3301923,1,0.8352941)
		_Secondary("Secondary", Color) = (0.2615309,0.1718138,0.3679245,0.945098)
		_SecondaryAdd("SecondaryAdd", Range( 0 , 2)) = 1.195647
		_Texture0("Texture 0", 2D) = "white" {}
		_Fade("Fade", Range( 0 , 5)) = 1
		_Speed("Speed", Range( -5 , 5)) = 0.92
		_AlphaMult("AlphaMult", Range( 0 , 3)) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGB
		ZWrite Off
		ZTest LEqual
		Offset 100 , 0
		
		
		
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


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
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

			uniform sampler2D _Texture0;
			uniform half _Speed;
			uniform half4 _Color0;
			uniform half _Fade;
			uniform half _SecondaryAdd;
			uniform half4 _Secondary;
			uniform half _AlphaMult;
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
				o.ase_color = v.color;
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
				half temp_output_292_0 = ( 0.25 * _Speed );
				half mulTime316 = _Time.y * temp_output_292_0;
				half temp_output_315_0 = ( mulTime316 * temp_output_292_0 );
				half2 texCoord105 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				half2 CenteredUV15_g10 = ( texCoord105 - float2( 0.5,0.5 ) );
				half2 break17_g10 = CenteredUV15_g10;
				half2 appendResult23_g10 = (half2(( length( CenteredUV15_g10 ) * 0.0 * 2.0 ) , ( atan2( break17_g10.x , break17_g10.y ) * ( 1.0 / 6.28318548202515 ) * 2.0 )));
				half2 panner150 = ( temp_output_315_0 * float2( -0.17,0.5 ) + appendResult23_g10);
				half temp_output_302_0 = ( 0.99 * tex2D( _Texture0, panner150 ).r );
				half MasterFade341 = _Fade;
				half2 texCoord331 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0 );
				half2 CenteredUV15_g9 = ( texCoord331 - float2( 0.5,0.5 ) );
				half2 break17_g9 = CenteredUV15_g9;
				half2 appendResult23_g9 = (half2(( length( CenteredUV15_g9 ) * 0.0 * 2.0 ) , ( atan2( break17_g9.x , break17_g9.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				half2 panner332 = ( temp_output_315_0 * float2( 0.3,-0.5 ) + appendResult23_g9);
				half4 tex2DNode330 = tex2D( _Texture0, panner332 );
				Gradient gradient612 = NewGradient( 0, 2, 2, float4( 0, 0, 0, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 0, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				half2 texCoord605 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				half2 CenteredUV15_g8 = ( texCoord605 - float2( 0.5,0.5 ) );
				half2 break17_g8 = CenteredUV15_g8;
				half2 appendResult23_g8 = (half2(( length( CenteredUV15_g8 ) * 0.12 * 2.0 ) , ( atan2( break17_g8.x , break17_g8.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				half temp_output_643_0 = saturate( pow( ( 1.0 - ( saturate( SampleGradient( gradient612, appendResult23_g8.x ).r ) * 60.0 ) ) , 5.8 ) );
				half4 break628 = saturate( ( ( temp_output_302_0 * _Color0 * MasterFade341 ) + ( ( ( tex2DNode330.r + temp_output_643_0 ) * ( _SecondaryAdd * MasterFade341 ) ) * _Secondary * MasterFade341 ) ) );
				half temp_output_647_0 = saturate( ( ( break628.b * temp_output_643_0 ) * ( ( _Color0.a * i.ase_color.a ) * _AlphaMult ) ) );
				half4 appendResult629 = (half4(break628.r , break628.g , break628.b , temp_output_647_0));
				
				
				finalColor = saturate( ( appendResult629 * temp_output_647_0 ) );
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
Node;AmplifyShaderEditor.RangedFloatNode;303;-651.9298,-83.90579;Inherit;False;Constant;_TexMult;TexMult;8;0;Create;True;0;0;0;False;0;False;0.99;0.99;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;-277.9298,-29.90576;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;-1586.672,843.4905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;295;-549.3752,561.6177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;123.8917,-24.0688;Inherit;False;Tex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;330;-881.2869,850.1581;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-842.9127,248.3297;Inherit;True;Property;_Beams;Beams;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;290;-2479.886,327.5048;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2261.605,394.9175;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;316;-1998.116,341.6867;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;-1746.159,371.3853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-2758.991,414.7987;Inherit;False;Property;_Speed;Speed;5;0;Create;True;0;0;0;False;0;False;0.92;-0.92;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;627;-1855.083,197.7217;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;626;-2068.177,172.4869;Inherit;False;Property;_UVCenterV;UVCenterV;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;625;-2065.374,85.56684;Inherit;False;Property;_UVCenterU;UVCenterU;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;329;-1125.79,530.3973;Inherit;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;0;False;0;False;21b46c6e6bfb16e4abfced00ad9152cd;283ecf1283a72244383b6e9ab106f330;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;297;-405.925,635.9745;Inherit;False;Property;_SecondaryAdd;SecondaryAdd;2;0;Create;True;0;0;0;False;0;False;1.195647;0.907;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;332;-1290.859,844.414;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.3,-0.5;False;1;FLOAT;0.25;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;630;-344.7328,404.0111;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;146;-369.7176,213.2636;Half;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0.3301923,1,0.8352941;0.1199269,0.5197599,0.7264151,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;342.088,108.1011;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;-442.5657,999.0343;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;182;228.6646,917.6418;Half;False;Property;_Secondary;Secondary;1;0;Create;True;0;0;0;False;0;False;0.2615309,0.1718138,0.3679245,0.945098;0.08027763,0.2475218,0.4150943,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;547.5215,951.3114;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;-64.5184,817.2029;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;261.3244,636.2928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;631;264.1116,427.9503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;642;650.3158,826.8387;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;641;126.5791,252.2124;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;345;231.3654,1136.804;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;336;-579.2913,-377.6725;Inherit;False;Property;_Fade;Fade;4;0;Create;True;0;0;0;False;0;False;1;4.23;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;341;-305.7452,-377.8206;Inherit;False;MasterFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;639;703.3701,1202.958;Inherit;False;Property;_AlphaMult;AlphaMult;8;0;Create;True;0;0;0;False;0;False;1;0.858;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;628;1715.207,552.3006;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;604;2020.962,718.4523;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;622;1152.638,1563.295;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;624;1363.889,1579.011;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;5.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;643;1619.74,1703.416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;620;938.5358,1563.719;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;60;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;623;776.916,1608.015;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;611;479.4023,1568.868;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;612;267.863,1555.63;Inherit;False;0;2;2;0,0,0,0;1,1,1,1;0,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.FunctionNode;603;184.1953,1652.823;Inherit;True;Polar Coordinates;-1;;8;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.12;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;605;-27.94144,1641.425;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;638;1287.35,772.774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;644;1556.746,1016.916;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;629;2524.012,608.2923;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;635;2297.478,1011.117;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;846.6843,516.2269;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;646;3024.878,838.2621;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;311;3573.76,77.25544;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_powerup_backshine;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;True;100;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;606;3288.809,528.1729;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;600;-1510.674,545.3223;Inherit;False;Polar Coordinates;-1;;9;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;150;-1292.631,284.9671;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.17,0.5;False;1;FLOAT;0.25;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;602;-1605.307,2.239192;Inherit;False;Polar Coordinates;-1;;10;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;647;2628.486,1067.841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;105;-2064.45,-89.63148;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;331;-1886.643,649.5801;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;645;1191.334,396.068;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;649;1499.41,1450.058;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;648;-368.23,1268.08;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;302;0;303;0
WireConnection;302;1;6;1
WireConnection;349;0;315;0
WireConnection;295;0;330;1
WireConnection;165;0;302;0
WireConnection;330;0;329;0
WireConnection;330;1;332;0
WireConnection;6;0;329;0
WireConnection;6;1;150;0
WireConnection;292;0;290;0
WireConnection;292;1;291;0
WireConnection;316;0;292;0
WireConnection;315;0;316;0
WireConnection;315;1;292;0
WireConnection;627;0;625;0
WireConnection;627;1;626;0
WireConnection;332;0;600;0
WireConnection;332;1;349;0
WireConnection;147;0;302;0
WireConnection;147;1;146;0
WireConnection;147;2;641;0
WireConnection;298;0;296;0
WireConnection;298;1;182;0
WireConnection;298;2;345;0
WireConnection;347;0;297;0
WireConnection;347;1;344;0
WireConnection;296;0;648;0
WireConnection;296;1;347;0
WireConnection;631;0;146;4
WireConnection;631;1;630;4
WireConnection;642;0;631;0
WireConnection;341;0;336;0
WireConnection;628;0;645;0
WireConnection;604;0;628;2
WireConnection;604;1;643;0
WireConnection;622;0;620;0
WireConnection;624;0;622;0
WireConnection;643;0;624;0
WireConnection;620;0;623;0
WireConnection;623;0;611;1
WireConnection;611;0;612;0
WireConnection;611;1;603;0
WireConnection;603;1;605;0
WireConnection;638;0;642;0
WireConnection;638;1;639;0
WireConnection;644;0;638;0
WireConnection;629;0;628;0
WireConnection;629;1;628;1
WireConnection;629;2;628;2
WireConnection;629;3;647;0
WireConnection;635;0;604;0
WireConnection;635;1;644;0
WireConnection;183;0;147;0
WireConnection;183;1;298;0
WireConnection;646;0;629;0
WireConnection;646;1;647;0
WireConnection;311;0;606;0
WireConnection;606;0;646;0
WireConnection;600;1;331;0
WireConnection;150;0;602;0
WireConnection;150;1;315;0
WireConnection;602;1;105;0
WireConnection;647;0;635;0
WireConnection;645;0;183;0
WireConnection;649;0;643;0
WireConnection;648;0;330;1
WireConnection;648;1;649;0
ASEEND*/
//CHKSM=7413C3E2D04EC6FEF3A2D763EFF0C18EEC2F5141