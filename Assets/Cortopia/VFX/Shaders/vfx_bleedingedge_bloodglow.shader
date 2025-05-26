// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_bleedingedge_bloodglow"
{
	Properties
	{
		_Fade("Fade", Range( 0 , 1)) = 1
		_ColorBase("ColorBase", Color) = (0,0.07380676,0.5283019,1)
		_VisualNoise("VisualNoise", 2D) = "white" {}
		_ShapeNoise("ShapeNoise", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Front
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				half3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _Fade;
			uniform sampler2D _ShapeNoise;
			uniform half4 _ShapeNoise_ST;
			uniform half4 _ColorBase;
			uniform sampler2D _VisualNoise;
			uniform half4 _VisualNoise_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				half2 appendResult552 = (half2(0.1 , 0.2));
				half2 uv_ShapeNoise = v.ase_texcoord.xy * _ShapeNoise_ST.xy + _ShapeNoise_ST.zw;
				half2 panner544 = ( -1.0 * _Time.y * ( appendResult552 * -0.2 ) + uv_ShapeNoise);
				
				half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( ( ( _Fade * tex2Dlod( _ShapeNoise, float4( panner544, 0, 0.0) ).r ) * 0.015 ) * v.ase_normal ) * v.color.r );
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
				half4 temp_output_265_0 = saturate( _ColorBase );
				half4 break529 = temp_output_265_0;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				half3 ase_worldNormal = i.ase_texcoord1.xyz;
				half fresnelNdotV571 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode571 = ( 0.0 + 7.0 * pow( 1.0 - fresnelNdotV571, 2.23 ) );
				half2 appendResult613 = (half2(0.0 , 0.05));
				half2 uv_VisualNoise = i.ase_texcoord2.xy * _VisualNoise_ST.xy + _VisualNoise_ST.zw;
				half2 panner586 = ( 1.0 * _Time.y * appendResult613 + uv_VisualNoise);
				half2 appendResult617 = (half2(0.0 , 0.08));
				half2 panner618 = ( 1.0 * _Time.y * appendResult617 + uv_VisualNoise);
				half temp_output_572_0 = ( fresnelNode571 * ( tex2D( _VisualNoise, panner586 ).r * tex2D( _VisualNoise, panner618 ).r ) * 0.5996982 );
				half smoothstepResult583 = smoothstep( 0.05 , 0.07 , saturate( temp_output_572_0 ));
				half4 appendResult530 = (half4(break529.r , break529.g , break529.b , ( ( smoothstepResult583 * ( _ColorBase.a * 1.0 ) ) * _Fade )));
				
				
				finalColor = appendResult530;
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
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-835.7007,1606.052;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;550;-2527.731,2693.282;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;551;-2527.731,2773.282;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;552;-2383.731,2693.282;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;553;-2159.731,2565.282;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;265;-1429.664,1517.079;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;597;-1898.178,1322.362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;581;-1117.118,903.1265;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;582;-1718.7,1141.268;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;600;-2613.094,567.1082;Inherit;False;Standard;WorldNormal;ViewDir;True;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2.58;False;3;FLOAT;1.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;530;-570.7444,1588.26;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;568;-1473.895,1868.663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;478;-1978.052,1608.51;Inherit;False;Property;_ColorBase;ColorBase;1;0;Create;True;0;0;0;False;0;False;0,0.07380676,0.5283019,1;0.1215686,0.8980393,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;587;-3753.03,1150.647;Inherit;False;Property;_NoiseTile;NoiseTile;2;0;Create;True;0;0;0;False;0;False;0;0.155;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;544;-1858.269,2638.601;Inherit;False;3;0;FLOAT2;5,5;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalVertexDataNode;555;-254.9691,2915.992;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;556;71.46757,2705.483;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;611;601.3914,2820.36;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;612;449.3914,3012.36;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;578;-1188.927,1330.197;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;540;-960.3344,1405.051;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;577;-1441.326,856.2972;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.71;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;605;-2713.213,1643.312;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;606;-3331.891,1331.35;Inherit;False;0;590;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;613;-3175.418,1523.993;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;586;-2968.805,1451.382;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;617;-3461.919,2270.517;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;618;-3255.306,2197.906;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;619;-2258.01,1890.378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;614;-2697.96,2014.431;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;0;False;0;False;-1;283ecf1283a72244383b6e9ab106f330;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;616;-3618.393,2077.874;Inherit;False;0;590;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;576;-2138.104,599.0285;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;599;-1847.094,626.7083;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;601;-2373.387,448.3817;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;571;-2568.952,791.796;Inherit;True;Standard;WorldNormal;ViewDir;True;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;7;False;3;FLOAT;2.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;572;-2106.316,950.0823;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;608;-2201.277,2319.272;Inherit;False;0;607;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;741.8466,1626.183;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_bleedingedge_bloodglow;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;True;True;False;0;False;;255;False;;255;False;;2;False;;3;False;;3;False;;1;False;;1;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;False;100;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638587125945191860;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-960.3668,1858.789;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;547;-657.0244,2563.497;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;620;-732.4388,2157.34;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1267.789,2328.327;Inherit;False;Property;_Fade;Fade;0;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-862.9661,2498.209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-2486.819,1063.412;Inherit;False;Constant;_TexBoost;TexBoost;1;0;Create;True;0;0;0;False;0;False;0.5996982;0.62;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;588;-3451.329,1636.152;Inherit;False;Constant;_NoiseSpeed1;NoiseSpeed1;6;0;Create;True;0;0;0;False;0;False;0.05;-0.95;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;615;-3739.272,2382.676;Inherit;False;Constant;_NoiseSpeed2;NoiseSpeed2;7;0;Create;True;0;0;0;False;0;False;0.08;-0.95;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;549;-2562.259,2492.985;Inherit;False;Constant;_ScrollSpeed;ScrollSpeed;3;0;Create;True;0;0;0;False;0;False;-0.2;0.15;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;567;-1962.807,1997.543;Inherit;False;Constant;_Opacity;Opacity;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;590;-3282.863,1799.089;Inherit;True;Property;_VisualNoise;VisualNoise;3;0;Create;True;0;0;0;False;0;False;283ecf1283a72244383b6e9ab106f330;283ecf1283a72244383b6e9ab106f330;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;607;-1402.904,2942.229;Inherit;True;Property;_ShapeNoise;ShapeNoise;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;545;-940.7319,2939.282;Inherit;False;Constant;_Shaper;Shaper;2;0;Create;True;0;0;0;False;0;False;0.015;0.763;0;0.13;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;583;-1562.039,1132.097;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.07;False;1;FLOAT;0
WireConnection;529;0;265;0
WireConnection;552;0;550;0
WireConnection;552;1;551;0
WireConnection;553;0;552;0
WireConnection;553;1;549;0
WireConnection;265;0;478;0
WireConnection;581;0;577;0
WireConnection;582;0;572;0
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;530;3;620;0
WireConnection;568;0;478;4
WireConnection;568;1;567;0
WireConnection;544;0;608;0
WireConnection;544;2;553;0
WireConnection;556;0;547;0
WireConnection;556;1;555;0
WireConnection;611;0;556;0
WireConnection;611;1;612;1
WireConnection;578;0;583;0
WireConnection;578;1;265;0
WireConnection;540;0;578;0
WireConnection;577;1;599;0
WireConnection;605;0;590;0
WireConnection;605;1;586;0
WireConnection;606;0;587;0
WireConnection;613;1;588;0
WireConnection;586;0;606;0
WireConnection;586;2;613;0
WireConnection;617;1;615;0
WireConnection;618;0;616;0
WireConnection;618;2;617;0
WireConnection;619;0;605;1
WireConnection;619;1;614;1
WireConnection;614;0;590;0
WireConnection;614;1;618;0
WireConnection;576;0;571;0
WireConnection;599;0;571;0
WireConnection;599;1;572;0
WireConnection;601;0;600;0
WireConnection;572;0;571;0
WireConnection;572;1;619;0
WireConnection;572;2;598;0
WireConnection;528;0;530;0
WireConnection;528;1;611;0
WireConnection;486;0;583;0
WireConnection;486;1;568;0
WireConnection;547;0;183;0
WireConnection;547;1;545;0
WireConnection;620;0;486;0
WireConnection;620;1;196;0
WireConnection;183;0;196;0
WireConnection;183;1;607;1
WireConnection;607;1;544;0
WireConnection;583;0;582;0
ASEEND*/
//CHKSM=9AE083647348BB91F97E89292184616961F478B9