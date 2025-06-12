// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_flash_mask_premult_hubglow"
{
	Properties
	{
		_FlashTex("FlashTex", 2D) = "white" {}
		_FlashU("FlashU", Float) = 0
		_FlashV("FlashV", Float) = 0
		_ContrastBoost("ContrastBoost", Range( 0 , 10)) = 2.67783
		[HDR]_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)
		_Erode("Erode", Range( 0 , 1)) = 0.5111656
		_PanX("PanX", Range( -10 , 10)) = 0
		_Spiking("Spiking", Range( 0 , 3)) = 0
		_PanY("PanY", Range( -10 , 10)) = 0
		_EdgeMult("EdgeMult", Range( -2 , 2)) = 0
		[Toggle]_InvertTex("InvertTex", Float) = 0

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
		ColorMask RGB
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1


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
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _ContrastBoost;
			uniform float4 _Color0;
			uniform float _InvertTex;
			uniform sampler2D _FlashTex;
			uniform float _PanX;
			uniform float _PanY;
			uniform float4 _FlashTex_ST;
			uniform float _FlashU;
			uniform float _FlashV;
			uniform float _Spiking;
			uniform float _EdgeMult;
			uniform float _Erode;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
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
				float smoothstepResult563 = smoothstep( 0.9 , 1.0 , i.ase_color.r);
				float4 temp_cast_0 = (( saturate( smoothstepResult563 ) * 0.2 )).xxxx;
				float2 appendResult537 = (float2(_PanX , _PanY));
				float2 appendResult469 = (float2(_FlashU , _FlashV));
				float2 texCoord482 = i.ase_texcoord1.xy * _FlashTex_ST.xy + ( _FlashTex_ST.zw + appendResult469 );
				float2 CenteredUV15_g2 = ( texCoord482 - float2( 0.5,0.5 ) );
				float2 break17_g2 = CenteredUV15_g2;
				float2 appendResult23_g2 = (float2(( length( CenteredUV15_g2 ) * _Spiking * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				float2 panner508 = ( 0.3 * _Time.y * appendResult537 + appendResult23_g2);
				float4 tex2DNode464 = tex2D( _FlashTex, panner508 );
				float smoothstepResult553 = smoothstep( _EdgeMult , 1.0 , ( 1.0 - ( i.ase_color.r * 2.5 ) ));
				float temp_output_546_0 = ( 1.0 - ( (( _InvertTex )?( ( 1.0 - tex2DNode464.r ) ):( tex2DNode464.r )) * smoothstepResult553 ) );
				float temp_output_547_0 = ( _Erode * saturate( temp_output_546_0 ) );
				float temp_output_265_0 = saturate( ( ( ( saturate( temp_output_546_0 ) * temp_output_547_0 ) - ( 1.0 - temp_output_547_0 ) ) / temp_output_547_0 ) );
				float4 break529 = ( _ContrastBoost * ( ( _Color0 * i.ase_color.r ) - temp_cast_0 ) * temp_output_265_0 );
				float4 appendResult530 = (float4(break529.r , break529.g , break529.b , ( break529.a * ( 1.0 - temp_output_265_0 ) )));
				
				
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
Node;AmplifyShaderEditor.OneMinusNode;399;-2850.708,1570.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-3269.69,1491.58;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-2676.731,1475.686;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-1019.554,1612.526;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;509;-5393.383,1437.734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;536;-6332.042,1682.698;Inherit;False;Property;_PanY;PanY;8;0;Create;True;0;0;0;False;0;False;0;0.05;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;537;-6030.255,1622.34;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;514;-4023.588,2225.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;546;-4087.953,1475.377;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;-4370.392,1315.319;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;547;-3510.973,2142.832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;401;-2411.184,1732.327;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;530;-534.9446,1606.69;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;508;-5792.413,1535.238;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;467;-6749.272,1268.401;Inherit;False;Property;_FlashU;FlashU;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;469;-6551.04,1304.327;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;466;-6416.811,1123.063;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;482;-6358.5,901.923;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;465;-6733.521,950.6028;Inherit;False;464;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;468;-6716.603,1413.785;Inherit;False;Property;_FlashV;FlashV;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;550;-6085.063,1021.778;Inherit;False;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;-0.03;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;510;-6373.758,1564.541;Inherit;False;Property;_PanX;PanX;6;0;Create;True;0;0;0;False;0;False;0;-0.08;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;554;-6319.757,1284.465;Inherit;False;Property;_Spiking;Spiking;7;0;Create;True;0;0;0;False;0;False;0;0.015;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;541;-4831.55,1670.749;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;195;-5203.851,1687.103;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;553;-4561.159,1679.765;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;552;-5067.522,2053.817;Inherit;False;Property;_EdgeMult;EdgeMult;9;0;Create;True;0;0;0;False;0;False;0;-1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;548;-796.8782,1859.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;265;-1929.063,1693.388;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-1355.031,1495.03;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;478;-2781.287,934.9615;Inherit;False;Property;_Color0;Color 0;4;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;0,0.7817461,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;517;-3082.508,1201.537;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;495;-3693.911,1391.828;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-3892.32,2091.45;Inherit;False;Property;_Erode;Erode;5;0;Create;True;0;0;0;False;0;False;0.5111656;0.53;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;562;-2152.275,1175.071;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;545;-2522.25,1143.568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1834.386,1243.115;Inherit;False;Property;_ContrastBoost;ContrastBoost;3;0;Create;True;0;0;0;False;0;False;2.67783;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;544;-1483.055,1868.81;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;563;-2649.454,1273.196;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;564;-2470.824,1274.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;449.6607,1789.456;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_flash_mask_premult_hubglow;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;638669249716919711;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SamplerNode;464;-5068.353,1055.611;Inherit;True;Property;_FlashTex;FlashTex;0;0;Create;True;0;0;0;False;0;False;-1;None;f0993f63673e5a948abfebd31b88dce2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;573;-4458.232,1066.057;Inherit;False;Property;_InvertTex;InvertTex;10;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;572;-4637.793,1128.983;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;565;-2300.862,1271.743;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;561;-4999.959,1780.289;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;574;-5657.678,1403.81;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
WireConnection;399;0;547;0
WireConnection;433;0;495;0
WireConnection;433;1;547;0
WireConnection;397;0;433;0
WireConnection;397;1;399;0
WireConnection;529;0;183;0
WireConnection;537;0;510;0
WireConnection;537;1;536;0
WireConnection;514;0;546;0
WireConnection;546;0;491;0
WireConnection;491;0;573;0
WireConnection;491;1;553;0
WireConnection;547;0;479;0
WireConnection;547;1;514;0
WireConnection;401;0;397;0
WireConnection;401;1;547;0
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;530;3;548;0
WireConnection;508;0;550;0
WireConnection;508;2;537;0
WireConnection;469;0;467;0
WireConnection;469;1;468;0
WireConnection;466;0;465;1
WireConnection;466;1;469;0
WireConnection;482;0;465;0
WireConnection;482;1;466;0
WireConnection;550;1;482;0
WireConnection;550;3;554;0
WireConnection;541;0;561;0
WireConnection;553;0;541;0
WireConnection;553;1;552;0
WireConnection;548;0;529;3
WireConnection;548;1;544;0
WireConnection;265;0;401;0
WireConnection;183;0;196;0
WireConnection;183;1;562;0
WireConnection;183;2;265;0
WireConnection;495;0;546;0
WireConnection;562;0;545;0
WireConnection;562;1;565;0
WireConnection;545;0;478;0
WireConnection;545;1;517;1
WireConnection;544;0;265;0
WireConnection;563;0;517;1
WireConnection;564;0;563;0
WireConnection;528;0;530;0
WireConnection;464;1;508;0
WireConnection;573;0;464;1
WireConnection;573;1;572;0
WireConnection;572;0;464;1
WireConnection;565;0;564;0
WireConnection;561;0;195;1
WireConnection;574;0;508;0
ASEEND*/
//CHKSM=514448AE4761C310DED53EFC5D7E5960E5317D01