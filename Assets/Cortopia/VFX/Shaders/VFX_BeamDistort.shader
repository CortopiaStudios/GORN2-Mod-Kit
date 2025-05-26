// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_BeamDistort"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_SpeedNoise("SpeedNoise", Float) = 0.5
		[HDR]_Color1("Color 1", Color) = (0,0.4681206,1,1)
		_NoiseLerp("NoiseLerp", Range( 0 , 1)) = 0.3589172
		_UVModulate("UVModulate", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


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

			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float _SpeedNoise;
			uniform sampler2D _UVModulate;
			uniform float4 _UVModulate_ST;
			uniform float _NoiseLerp;
			uniform float4 _Color1;

			
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
				float2 texCoord62 = i.ase_texcoord1.xy * float2( 1,2 ) + float2( 0,-0.5 );
				float smoothstepResult109 = smoothstep( 0.03 , 0.31 , ( ( ( 1.0 - texCoord62.y ) * texCoord62.y ) * 0.7 ));
				float2 texCoord125 = i.ase_texcoord1.xy * float2( 1,1.3 ) + float2( 0,-0.14 );
				float temp_output_101_0 = ( saturate( ( smoothstepResult109 + saturate( ( ( ( 1.0 - texCoord125.y ) * texCoord125.y ) * 0.3 ) ) ) ) * 0.1 );
				float2 appendResult92 = (float2(1.0 , 0.0));
				float2 appendResult56 = (float2(0.81 , 0.0));
				float2 appendResult34 = (float2(( _SpeedNoise * -0.5 ) , _SpeedNoise));
				float2 uv_UVModulate = i.ase_texcoord1.xy * _UVModulate_ST.xy + _UVModulate_ST.zw;
				float2 panner45 = ( 1.0 * _Time.y * appendResult34 + uv_UVModulate);
				float2 temp_cast_0 = (tex2D( _UVModulate, panner45 ).r).xx;
				float2 lerpResult46 = lerp( panner45 , temp_cast_0 , _NoiseLerp);
				float2 panner10 = ( 1.0 * _Time.y * appendResult56 + lerpResult46);
				float2 texCoord9 = i.ase_texcoord1.xy * _Texture0_ST.xy + ( _Texture0_ST.zw + ( appendResult92 * panner10 ) );
				float temp_output_132_0 = ( tex2D( _Texture0, texCoord9 ).r * 2.0 );
				float temp_output_86_0 = ( temp_output_101_0 * temp_output_132_0 );
				float smoothstepResult122 = smoothstep( 0.5 , 2.0 , distance( WorldPosition , _WorldSpaceCameraPos ));
				
				
				finalColor = ( saturate( ( ( saturate( temp_output_86_0 ) + saturate( ( ( temp_output_101_0 + temp_output_132_0 ) * saturate( ( temp_output_86_0 + saturate( _Color1 ) ) ) ) ) ) * i.ase_color.a ) ) * smoothstepResult122 );
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
Node;AmplifyShaderEditor.SaturateNode;100;1887.836,408.7083;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;750.0208,-5.50655;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;130;871.6982,-582.6848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;99;1189.191,-544.1017;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;1196.471,-277.9869;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;131;918.8225,-310.606;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;546.7133,-552.2994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1593.091,287.4548;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;285.5522,-1209.053;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;95;1084.921,233.2432;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;118;2107.669,1097.703;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;116;1755.669,1001.703;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;117;1707.669,1209.703;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;122;2299.669,1113.703;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;2105.727,1313.529;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;2107.727,1434.529;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;2023.256,4.856194;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;93;501.4545,182.7853;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-430.7478,-282.2212;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-663.1129,-178.1348;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-487.0936,89.66049;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;853ee654037b5a44caa65bb66426e208;853ee654037b5a44caa65bb66426e208;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;10;-1124.301,35.3208;Inherit;True;3;0;FLOAT2;0.25,0;False;2;FLOAT2;0.25,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1316.718,389.0039;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1576.066,465.0753;Inherit;False;Constant;_PannerMult;PannerMult;3;0;Create;True;0;0;0;False;0;False;0.81;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;92;-1030.074,-110.4071;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1242.801,-176.2955;Inherit;False;Constant;_PannerSplitMult;PannerSplitMult;1;0;Create;True;0;0;0;False;0;False;1;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1654.901,28.05067;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;72;-2081.71,185.1558;Inherit;True;Property;_UVModulate;UVModulate;5;0;Create;True;0;0;0;False;0;False;-1;dfefd45a87f80d344ad079e21d5da47c;21b46c6e6bfb16e4abfced00ad9152cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1974.186,477.4869;Inherit;False;Property;_NoiseLerp;NoiseLerp;3;0;Create;True;0;0;0;False;0;False;0.3589172;0.104;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;60;-3235.363,-31.46931;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-3047.756,-116.2535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-2910.364,-9.369488;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2634.721,358.531;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2747.009,107.7897;Inherit;False;0;72;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;45;-2335.536,30.71962;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3293.161,-195.2686;Inherit;False;Property;_NoiseUVMult;NoiseUVMult;4;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;52;-3608.497,123.5899;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;6;-85.37668,-105.4433;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;-116.4124,-887.8762;Inherit;False;Constant;_GlowIntensity;GlowIntensity;10;0;Create;True;0;0;0;False;0;False;0.1;0.42;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;128;34.00925,-1208.587;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1355.856,-1217.16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1412.749,-791.6066;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;129;-758.9131,-672.7629;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-1817.246,-1334.364;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1075.773,-1231.406;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;-1555.581,-1327.633;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;109;-789.2021,-1230.8;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.03;False;2;FLOAT;0.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-1188.189,-802.0437;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-316.6063,-1210.502;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;125;-1865.004,-819.1505;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1.3;False;1;FLOAT2;0,-0.14;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;126;-1604.645,-890.9283;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;77;3191.802,997.1024;Float;False;True;-1;2;ASEMaterialInspector;100;5;VFX_BeamDistort;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;2560,1008;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;32.81385,438.5863;Inherit;False;Property;_Color1;Color 1;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0.4681206,1,1;1.517149,0,0.02731139,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;307.4573,-242.4104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;133;2539.902,524.5701;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;2266.69,461.3478;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;135;2007.086,596.2396;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-3129.321,371.6309;Inherit;False;Property;_SpeedNoise;SpeedNoise;1;0;Create;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;5;-1068.567,-314.1734;Inherit;False;7;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-838.1539,-106.2388;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-2843.412,301.2139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
WireConnection;100;0;22;0
WireConnection;84;0;86;0
WireConnection;84;1;93;0
WireConnection;130;0;101;0
WireConnection;99;0;86;0
WireConnection;98;0;131;0
WireConnection;98;1;132;0
WireConnection;131;0;130;0
WireConnection;86;0;101;0
WireConnection;86;1;132;0
WireConnection;22;0;98;0
WireConnection;22;1;95;0
WireConnection;101;0;128;0
WireConnection;101;1;102;0
WireConnection;95;0;84;0
WireConnection;118;0;116;0
WireConnection;118;1;117;0
WireConnection;122;0;118;0
WireConnection;122;1;123;0
WireConnection;122;2;124;0
WireConnection;96;0;99;0
WireConnection;96;1;100;0
WireConnection;93;0;29;0
WireConnection;9;0;5;0
WireConnection;9;1;11;0
WireConnection;11;0;5;1
WireConnection;11;1;16;0
WireConnection;10;0;46;0
WireConnection;10;2;56;0
WireConnection;56;0;19;0
WireConnection;92;0;17;0
WireConnection;46;0;45;0
WireConnection;46;1;72;1
WireConnection;46;2;43;0
WireConnection;72;1;45;0
WireConnection;60;0;52;0
WireConnection;57;0;59;0
WireConnection;57;1;60;0
WireConnection;61;0;57;0
WireConnection;61;1;60;1
WireConnection;34;0;78;0
WireConnection;34;1;33;0
WireConnection;36;0;61;0
WireConnection;36;1;52;1
WireConnection;45;0;36;0
WireConnection;45;2;34;0
WireConnection;6;0;7;0
WireConnection;6;1;9;0
WireConnection;128;0;80;0
WireConnection;64;0;63;0
WireConnection;64;1;62;2
WireConnection;127;0;126;0
WireConnection;127;1;125;2
WireConnection;129;0;110;0
WireConnection;81;0;64;0
WireConnection;63;0;62;2
WireConnection;109;0;81;0
WireConnection;110;0;127;0
WireConnection;80;0;109;0
WireConnection;80;1;129;0
WireConnection;126;0;125;2
WireConnection;77;0;119;0
WireConnection;119;0;133;0
WireConnection;119;1;122;0
WireConnection;132;0;6;1
WireConnection;133;0;134;0
WireConnection;134;0;96;0
WireConnection;134;1;135;4
WireConnection;16;0;92;0
WireConnection;16;1;10;0
WireConnection;78;0;33;0
ASEEND*/
//CHKSM=145103C1D907954749BFFD4991710937E8F762B8