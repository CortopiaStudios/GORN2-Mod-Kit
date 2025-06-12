// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_flash_mask_premult_deform"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_FlashTex("FlashTex", 2D) = "white" {}
		_Shaper("Shaper", Range( 0 , 15)) = 0.68
		_Bulge("Bulge", Float) = 0
		_Noise("Noise", 2D) = "white" {}
		[Toggle]_ErodemanualvertexcolA("Erode manual/vertexcol(A)", Float) = 1
		_ContrastBoost("ContrastBoost", Range( 0 , 10)) = 2.67783
		[HDR]_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)
		_Erode("Erode", Range( 0 , 1)) = 0.5111656
		_Pan("Pan", Range( -1 , 1)) = 0
		_ScrollSpeed("ScrollSpeed", Range( -5 , 5)) = 0

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
		Cull Off
		ColorMask RGBA
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
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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

			uniform sampler2D _Noise;
			uniform float _ScrollSpeed;
			uniform float4 _Noise_ST;
			uniform float _Shaper;
			uniform float _Bulge;
			uniform float4 _Color0;
			uniform float _ContrastBoost;
			uniform sampler2D _Mask;
			uniform float4 _Mask_ST;
			uniform sampler2D _FlashTex;
			uniform float _Pan;
			uniform float4 _FlashTex_ST;
			uniform float _ErodemanualvertexcolA;
			uniform float _Erode;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult541 = (float2(0.1 , 0.0));
				float2 texCoord544 = v.ase_texcoord.xy * _Noise_ST.xy + _Noise_ST.zw;
				float2 panner546 = ( -1.0 * _Time.y * ( appendResult541 * _ScrollSpeed ) + texCoord544);
				float4 tex2DNode548 = tex2Dlod( _Noise, float4( panner546, 0, 0.0) );
				float3 break561 = v.ase_normal;
				float3 appendResult562 = (float3(break561.x , break561.y , break561.z));
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( v.color.r * ( (0.0 + (( tex2DNode548.r * _Shaper ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * appendResult562 ) ) * _Bulge );
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
				float2 texCoord481 = i.ase_texcoord1.xy * _Mask_ST.xy + _Mask_ST.zw;
				float4 tex2DNode463 = tex2D( _Mask, texCoord481 );
				float2 temp_cast_0 = (_Pan).xx;
				float2 texCoord482 = i.ase_texcoord1.xy * _FlashTex_ST.xy + _FlashTex_ST.zw;
				float2 panner508 = ( 0.3 * _Time.y * temp_cast_0 + texCoord482);
				float temp_output_496_0 = saturate( tex2D( _FlashTex, panner508 ).r );
				float4 break529 = saturate( saturate( ( _Color0 * saturate( ( _ContrastBoost * ( ( ( saturate( ( tex2DNode463.r * temp_output_496_0 ) ) * (( _ErodemanualvertexcolA )?( saturate( i.ase_color.a ) ):( _Erode )) ) - ( 1.0 - (( _ErodemanualvertexcolA )?( saturate( i.ase_color.a ) ):( _Erode )) ) ) / (( _ErodemanualvertexcolA )?( saturate( i.ase_color.a ) ):( _Erode )) ) ) ) ) ) );
				float2 appendResult541 = (float2(0.1 , 0.0));
				float2 texCoord544 = i.ase_texcoord1.xy * _Noise_ST.xy + _Noise_ST.zw;
				float2 panner546 = ( -1.0 * _Time.y * ( appendResult541 * _ScrollSpeed ) + texCoord544);
				float4 tex2DNode548 = tex2D( _Noise, panner546 );
				float4 appendResult530 = (float4(break529.r , break529.g , break529.b , ( break529.a * ( _Color0.a * i.ase_color.a * tex2DNode548.r ) )));
				
				
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
Node;AmplifyShaderEditor.TextureTransformNode;472;-5696.612,161.401;Inherit;False;463;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;464;-5036.375,826.3401;Inherit;True;Property;_FlashTex;FlashTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;481;-5238.033,158.389;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;496;-4553.195,1036.879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;463;-4937.351,372.7737;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;0;False;0;False;-1;None;853ee654037b5a44caa65bb66426e208;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;514;-4023.588,2225.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-4042.955,1978.349;Inherit;False;Property;_Erode;Erode;8;0;Create;True;0;0;0;False;0;False;0.5111656;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;495;-3570.238,1488.448;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;186;-3629.526,1920.78;Inherit;False;Property;_ErodemanualvertexcolA;Erode manual/vertexcol(A);5;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;399;-2850.708,1570.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;521;-2628.864,1944.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-3269.69,1491.58;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-2676.731,1475.686;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;523;-2551.085,1927.885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;401;-2399.235,1785.245;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-2410.115,1529.549;Inherit;False;Property;_ContrastBoost;ContrastBoost;6;0;Create;True;0;0;0;False;0;False;2.67783;3.79;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-2139.685,1592.441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;478;-2326.971,676.4628;Inherit;False;Property;_Color0;Color 0;7;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;0.1940038,0.2323044,0.6970984,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;265;-1931.731,1693.538;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-1682.828,1417.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;515;-1425.33,1443.126;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;517;-2301.942,923.9631;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;516;-1154.354,1467.427;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-1019.554,1612.526;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;-1931.433,897.1116;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;532;-833.0843,1904.67;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;530;-609.6335,1645.101;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;534;-3908.922,677.3562;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;-4220.298,1081.418;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;535;-4096.93,952.4266;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;537;-3497.616,3557.351;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;538;-3492.616,3639.351;Inherit;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;541;-3356.696,3557.351;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;544;-2950.846,3125.506;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;545;-3132.958,3422.273;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;548;-2371.616,3096.976;Inherit;True;Property;_Noise;Noise;4;0;Create;True;0;0;0;False;0;False;-1;None;204cd928e761305469a2ef1af3831454;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;554;-974.3994,3509.72;Inherit;False;Property;_Bulge;Bulge;3;0;Create;True;0;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;559;-495.2256,3202.985;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;546;-2726.252,3445.504;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;542;-3242.932,3131.997;Inherit;False;548;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;540;-3530.211,3323.244;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;10;0;Create;True;0;0;0;False;0;False;0;-1.19;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;551;-2063.658,3293.286;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;465;-6139.584,791.7075;Inherit;False;464;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;482;-5764.564,743.0276;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;510;-5767.658,1053.663;Inherit;False;Property;_Pan;Pan;9;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;508;-5392.732,922.9598;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;195;-4269.896,2164.546;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;553;-1338.073,3394.218;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;562;-1548.786,3519.38;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;561;-1885.425,3533.451;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PosVertexDataNode;563;-2674.389,3905.353;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;566;-1121.571,3156.039;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;567;-1468.571,3002.039;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;550;-2432.849,3526.144;Inherit;False;Property;_Shaper;Shaper;2;0;Create;True;0;0;0;False;0;False;0.68;7.05;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;552;-1776.069,3204.015;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;560;-2288.384,3705.506;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;-1713.598,3700.275;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;569;150.5209,2379.937;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_flash_mask_premult_deform;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;464;1;508;0
WireConnection;481;0;472;0
WireConnection;481;1;472;1
WireConnection;496;0;464;1
WireConnection;463;1;481;0
WireConnection;514;0;195;4
WireConnection;495;0;491;0
WireConnection;186;0;479;0
WireConnection;186;1;514;0
WireConnection;399;0;186;0
WireConnection;521;0;186;0
WireConnection;433;0;495;0
WireConnection;433;1;186;0
WireConnection;397;0;433;0
WireConnection;397;1;399;0
WireConnection;523;0;521;0
WireConnection;401;0;397;0
WireConnection;401;1;523;0
WireConnection;183;0;196;0
WireConnection;183;1;401;0
WireConnection;265;0;183;0
WireConnection;486;0;478;0
WireConnection;486;1;265;0
WireConnection;515;0;486;0
WireConnection;516;0;515;0
WireConnection;529;0;516;0
WireConnection;533;0;478;4
WireConnection;533;1;517;4
WireConnection;533;2;548;1
WireConnection;532;0;529;3
WireConnection;532;1;533;0
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;530;3;532;0
WireConnection;534;0;463;1
WireConnection;534;1;496;0
WireConnection;534;2;535;0
WireConnection;491;0;463;1
WireConnection;491;1;496;0
WireConnection;541;0;537;0
WireConnection;541;1;538;0
WireConnection;544;0;542;0
WireConnection;544;1;542;1
WireConnection;545;0;541;0
WireConnection;545;1;540;0
WireConnection;548;1;546;0
WireConnection;559;0;566;0
WireConnection;559;1;554;0
WireConnection;546;0;544;0
WireConnection;546;2;545;0
WireConnection;551;0;548;1
WireConnection;551;1;550;0
WireConnection;482;0;465;0
WireConnection;482;1;465;1
WireConnection;508;0;482;0
WireConnection;508;2;510;0
WireConnection;553;0;552;0
WireConnection;553;1;562;0
WireConnection;562;0;561;0
WireConnection;562;1;561;1
WireConnection;562;2;561;2
WireConnection;561;0;560;0
WireConnection;566;0;567;1
WireConnection;566;1;553;0
WireConnection;552;0;551;0
WireConnection;564;0;561;2
WireConnection;569;0;530;0
WireConnection;569;1;559;0
ASEEND*/
//CHKSM=91A6BF935C6A71FD6E49A9E42B8A6AB8A1E90F3F