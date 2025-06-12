// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_playerhealth_screenbleed"
{
	Properties
	{
		_Erode("Erode", Range( 0 , 0.98)) = 0.98
		_Spec("Spec", Range( 0 , 1)) = 1
		[HDR]_BaseColor("BaseColor", Color) = (1,0,0,1)
		[HDR]_Lucencycol("Lucencycol", Color) = (0.6509434,0,0.4581906,0.01960784)
		[HDR]_SpecColor("SpecColor", Color) = (27.3029,15.14408,1.858313,1)
		_Translucency("Translucency", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Normal]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_LucencyMult("LucencyMult", Range( 0 , 3)) = 0
		_NormalMult("NormalMult", Range( 0 , 5)) = 4.081872
		_SpecSharp("SpecSharp", Range( 1 , 10)) = 1
		_Brightness("Brightness", Range( 0.1 , 2)) = 0

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
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Translucency;
			uniform float _SpecSharp;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _NormalMult;
			uniform float _Erode;
			uniform float _Spec;
			uniform float4 _SpecColor;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float4 _BaseColor;
			uniform float4 _Lucencycol;
			uniform float _Brightness;
			uniform float _LucencyMult;

			
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
				float TranslucencySlider899 = _Translucency;
				float clampResult1054 = clamp( ( ( 0.07 + 0.1 ) * _SpecSharp ) , 0.0 , 1.0 );
				float2 texCoord1116 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float temp_output_724_0 = ( i.ase_color.a * _Erode );
				float Erodeval744 = temp_output_724_0;
				float clampResult1045 = clamp( ( Erodeval744 + 0.7 ) , 0.2 , 1.0 );
				float smoothstepResult782 = smoothstep( ( 0.07 * _SpecSharp ) , clampResult1054 , ( UnpackNormal( tex2D( _TextureSample1, texCoord1116 ) ).g * ( _NormalMult * clampResult1045 ) ));
				float temp_output_555_0 = saturate( ( saturate( smoothstepResult782 ) - ( ( 1.0 - _Spec ) + 0.23 ) ) );
				float temp_output_470_0 = saturate( ( 1.0 - temp_output_724_0 ) );
				float2 texCoord924 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode921 = tex2D( _TextureSample0, texCoord924 );
				float temp_output_927_0 = saturate( tex2DNode921.r );
				float Gradmask982 = temp_output_927_0;
				float temp_output_3_0_g5 = ( 0.15 - tex2DNode921.r );
				float Hardmask981 = saturate( ( 1.0 - saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) ) );
				float A563 = Hardmask981;
				float temp_output_1145_0 = saturate( A563 );
				float temp_output_610_0 = ( saturate( ( ( Gradmask982 - temp_output_470_0 ) / ( 1.0 - temp_output_1145_0 ) ) ) * temp_output_1145_0 );
				float Erosion819 = temp_output_610_0;
				float4 appendResult841 = (float4(_SpecColor.r , _SpecColor.g , _SpecColor.b , ( _SpecColor.a * ( temp_output_555_0 / temp_output_470_0 ) * Erosion819 )));
				float4 temp_output_644_0 = ( saturate( ( temp_output_555_0 * _Spec ) ) * appendResult841 );
				float4 GradSpec559 = ( ( ( 1.5 - TranslucencySlider899 ) * 0.8 ) * temp_output_644_0 );
				float4 break813 = GradSpec559;
				float3 appendResult855 = (float3(break813.x , break813.y , break813.z));
				float temp_output_948_0 = ( _BaseColor.a * Gradmask982 );
				float Translucency690 = ( 1.0 - saturate( ( Gradmask982 * 1.0 ) ) );
				float4 appendResult950 = (float4(_BaseColor.r , _BaseColor.g , _BaseColor.b , saturate( ( temp_output_948_0 - Translucency690 ) )));
				float clampResult747 = clamp( ( ( 1.0 - Erodeval744 ) * 3.0 ) , 0.0 , 1.0 );
				float temp_output_862_0 = saturate( ( saturate( ( clampResult747 * _Translucency * Translucency690 ) ) * 1.0 ) );
				float clampResult773 = clamp( temp_output_862_0 , 0.0 , 0.2 );
				float4 temp_cast_1 = (clampResult773).xxxx;
				float4 temp_output_780_0 = saturate( ( ( Hardmask981 * appendResult950 ) - temp_cast_1 ) );
				float temp_output_771_0 = saturate( Hardmask981 );
				float4 temp_cast_3 = (( 1.0 - temp_output_771_0 )).xxxx;
				float4 temp_output_700_0 = ( ( ( _Lucencycol * temp_output_862_0 ) - temp_cast_3 ) * ( temp_output_771_0 * 1.0 ) );
				float4 blendOpSrc1011 = temp_output_780_0;
				float4 blendOpDest1011 = temp_output_700_0;
				float4 break716 = ( saturate( ( ( blendOpSrc1011 + blendOpDest1011 ) * temp_output_610_0 ) ) * _Brightness );
				float BaseColAlphaUnmasked1069 = _BaseColor.a;
				float temp_output_958_0 = ( Erosion819 * _LucencyMult );
				float lerpResult1039 = lerp( Erosion819 , ( temp_output_958_0 - saturate( temp_output_958_0 ) ) , TranslucencySlider899);
				float SpecAlpha845 = temp_output_644_0.w;
				float4 appendResult715 = (float4(break716.r , break716.g , break716.b , saturate( ( ( BaseColAlphaUnmasked1069 - ( 1.0 - saturate( lerpResult1039 ) ) ) + SpecAlpha845 ) )));
				
				
				finalColor = saturate( ( float4( appendResult855 , 0.0 ) + appendResult715 ) );
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
Node;AmplifyShaderEditor.RegisterLocalVarNode;981;10667.69,4687.463;Inherit;False;Hardmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;887;8682.098,3820.87;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;876;7030.539,3651.085;Inherit;False;874;LucencyAlphaAdjust;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;864;6891.569,4299.933;Inherit;False;800;LucencyAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;903;7940.767,4102.224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;900;8416.586,3902.298;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;866;7373.772,3669.29;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1019;8893.915,3703.269;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1021;9114.518,3708.068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1039;10787.24,3457.044;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1040;10370.24,3555.044;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1032;10962.02,3545.938;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1067;11367.26,3915.091;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1068;11123.63,3900.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1071;11328.28,4094.613;Inherit;False;845;SpecAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;929;10249.37,4110.822;Inherit;False;wobble;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1028;10254.41,3834.864;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;818;10677.96,2178.922;Inherit;True;799;BaseAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;829;11104.23,2238.438;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;830;11359.65,2308.557;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;816;11551.87,2541.325;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;857;11778.26,2553.26;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;561;9608.589,2516.772;Inherit;True;559;GradSpec;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;813;9880.589,2516.772;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;822;10888.59,2500.772;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;820;10648.59,2484.772;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;811;10376.59,2388.772;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;827;10424.19,2612.62;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;821;10166.05,2574.021;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;855;10105.12,2780.439;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;831;11962.47,2800.733;Inherit;False;SpecBaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;844;11176.59,2788.772;Inherit;False;ErodingSpec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;911;11439.31,3291.176;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1076;10491.53,3211.847;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1077;10573.22,3279.923;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;716;9263.82,3341.195;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;465;4738.259,2365.304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;794;3593.839,3470.762;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;792;3330.916,3137.497;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;733;4115.262,2004.737;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;691;4244.364,2004.391;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;690;4415.904,1998.418;Inherit;True;Translucency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;470;3182.861,2393.185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;596;2636.604,2296.554;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;793;3297.607,2448.762;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;781;3614.237,742.1006;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;700;5175.975,1088.489;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;698;4667.848,373.7086;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;780;5125.592,1378.142;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;768;4814.614,1374.524;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;734;3410.552,746.7964;Inherit;True;3;3;0;FLOAT;1.91;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;744;3101.672,2126.556;Inherit;False;Erodeval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;914;4667.565,1076.381;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;663;3313.836,3121.301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;466;4180.391,2233.691;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;697;4068.011,367.1747;Inherit;False;Property;_Lucencycol;Lucencycol;3;1;[HDR];Create;True;0;0;0;False;0;False;0.6509434,0,0.4581906,0.01960784;1,0.1839623,0.1839623,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;819;5377.896,2682.164;Inherit;False;Erosion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;771;4286.427,1068.549;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;874;4309.334,598.3895;Inherit;False;LucencyAlphaAdjust;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;800;4622.144,745.9124;Inherit;True;LucencyAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;775;4815.649,967.9446;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;862;4331.364,747.3284;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;567;3538.427,1444.798;Inherit;False;Property;_BaseColor;BaseColor;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;948;3737.669,1763.54;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;774;4969.084,715.1536;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;986;5759.228,2226.782;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;773;4513.207,1171.886;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;899;3062.954,857.0245;Inherit;False;TranslucencySlider;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;735;2690.264,761.9725;Inherit;False;Property;_Translucency;Translucency;5;0;Create;True;0;0;0;False;0;False;0;0.363;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;746;2709.221,601.7005;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;2485.173,599.2525;Inherit;True;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;547;5457.935,1487.105;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0.4528302,0.4528302,0.4528302,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;747;3003.285,593.8106;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;745;2867.722,600.3775;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;553;3763.386,3318.977;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;740;3635.917,3297.743;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;782;3420.652,3215.735;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;642;4209.803,3569.081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;555;3906.486,3236.883;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;860;4531.346,3578.038;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;556;4129.971,3106.151;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;840;4935.908,3880.11;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;841;4377.126,3735.895;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;843;4134.218,3942.929;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;643;3753.903,3738.531;Inherit;False;Property;_SpecColor;SpecColor;4;1;[HDR];Create;True;0;0;0;False;0;False;27.3029,15.14408,1.858313,1;0.2075472,0.05776078,0.07850037,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;842;3701.855,4342.352;Inherit;False;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1056;4524.911,3459.195;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1057;5094.538,3601.299;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;2,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;4563.484,1391.01;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;950;4345.781,1476.309;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1009;4174.686,1672.24;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1069;3840.358,1587.202;Inherit;False;BaseColAlphaUnmasked;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1063;4915.704,3461.675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;558;2579.909,3656.62;Inherit;False;Property;_Spec;Spec;1;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;995;2235.312,3228.16;Inherit;False;Property;_NormalMult;NormalMult;9;0;Create;True;0;0;0;False;0;False;4.081872;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;641;2917.8,3593.719;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1049;2727.104,3336.89;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1052;3064.104,3298.891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1051;3065.104,3403.89;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1050;2732.104,3410.89;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1053;2771.104,3512.89;Inherit;False;Property;_SpecSharp;SpecSharp;10;0;Create;True;0;0;0;False;0;False;1;3.98;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1048;2887.104,3397.89;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1042;2092.014,3465.956;Inherit;False;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1045;2403.014,3478.956;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1043;2278.014,3459.956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1041;2549.759,3271.055;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1054;3249.695,3390.742;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;703;3104.362,3589.324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;859;5999.255,3352.825;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;1073;9482.945,4601.79;Inherit;False;Property;_GradMaskOrTexMask;GradMaskOrTexMask;12;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;964;7239.752,4707.881;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;966;7582.366,4799.567;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;965;7778.611,4732.01;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;969;8306.208,4735.226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;970;7600.462,5174.757;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;971;7796.707,5107.198;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;972;8055.673,5105.589;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;973;8282.482,5102.373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;976;8689.034,4875.168;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2.32;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;974;8479.924,4867.125;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;968;8037.578,4730.399;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;989;8907.66,4876.119;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1079;9322.304,4715.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1080;9414.304,4718.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1078;9327.304,4584.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1081;9400.304,4581.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1070;11550.12,3985.983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1066;11621.7,3624.266;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;901;8147.145,4033.688;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;715;12695.79,3324.829;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.32;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1097;3906.365,2364.441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1088;2939.815,5014.723;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1094;3689.188,4871.921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1100;2943.233,4721.427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1091;3157.518,4789.824;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1085;2671.616,4664.723;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1087;2725.815,4926.723;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1095;4049.884,4538.824;Inherit;False;ErodeFwd;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1101;4026.829,4737.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1099;3385.455,4812.644;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1102;3066.229,5177.586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1089;2700.815,5097.722;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1075;8847.738,4603.409;Inherit;True;Property;_SilhouetteMask;SilhouetteMask;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;962;913.767,3383.866;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;983;1527.804,3200.35;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1110;1140.874,2618.819;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1111;769.5615,2600.202;Inherit;False;Property;_SeqSpeedFPS;SeqSpeedFPS;11;0;Create;True;0;0;0;False;0;False;0;0;0;120;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1112;1018.1,2375.96;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1114;1219.836,2384.158;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1115;1437.991,2321.25;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1113;1131.62,2222.115;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;921;9200.496,4107.705;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;a659af092a5aba04ea98e5209f876ec9;a659af092a5aba04ea98e5209f876ec9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;845;5376.159,4125.653;Inherit;True;SpecAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;560;12956.38,3250.506;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;814;10127.08,2363.036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1109;1487.087,2757.313;Inherit;False;1108;FlipbookUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;670;1435.441,2852.476;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1108;9176.363,4454.702;Inherit;False;FlipbookUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;919;8803.432,4238.551;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;940;1208.582,3005.308;Inherit;True;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;942;1941.458,3200.274;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1047;1253.853,3430.642;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1122;10565.51,4053.452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1020;10628.11,3723.667;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;868;7803.776,3654.393;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;902;7808.862,3872.015;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;895;8110.567,3713.313;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;924;8497.061,4139.416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1103;8475.188,4462.338;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1107;8670.925,4499.536;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;1144;8244.873,4305.862;Inherit;False;921;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;563;3915.748,2688.05;Inherit;True;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1145;4122.72,2732.586;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;467;4288.34,2551.906;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;464;4513.119,2362.802;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;4937.496,2710.568;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;980;10311.12,4689.668;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1146;10500.29,4763.642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;975;9745.133,4593.485;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;2541.667,2485.632;Inherit;False;Property;_Erode;Erode;0;0;Create;True;0;0;0;False;0;False;0.98;0.576;0;0.98;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1096;3549.478,2502.356;Inherit;False;1095;ErodeFwd;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1116;1972.482,2763.831;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;994;2814.312,3127.163;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;644;4650.473,3711.785;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;559;5325.863,3729.529;Inherit;True;GradSpec;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1061;4758.133,3382.403;Inherit;False;2;0;FLOAT;1.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;668;2385.521,2756.82;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;1;[Normal];Create;True;0;0;0;False;0;False;921;e70579a3835ae5643876cb0313bfa665;e70579a3835ae5643876cb0313bfa665;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;1143;1620.552,2638.499;Inherit;False;668;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;714;14310.3,3234.009;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_playerhealth_screenbleed;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;5;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;834;13709.05,3232.786;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1150;8676.696,3426.952;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1151;8391.366,3601.832;Inherit;False;Property;_Brightness;Brightness;14;0;Create;True;0;0;0;False;0;False;0;0.445;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1065;11146.31,3768.061;Inherit;False;1069;BaseColAlphaUnmasked;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;870;7139.181,4162.648;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;897;7653.492,4105.463;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1003;9402.184,3805.577;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1027;9916.817,3798.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;960;9286.147,3947.374;Inherit;False;Property;_LucencyMult;LucencyMult;8;0;Create;True;0;0;0;False;0;False;0;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;958;10086.36,3550.121;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;957;9486.078,3452.327;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1011;5507.92,1095.368;Inherit;True;LinearDodge;False;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;597;3063.262,2480.67;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;724;2900.931,2385.545;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;772;4797.115,1083.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;694;3780.331,740.9834;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;565;3781.168,1189.79;Inherit;False;981;Hardmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1010;3974.448,1667.988;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;799;4721.458,1816.875;Inherit;False;BaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;693;3012.552,1586.85;Inherit;True;690;Translucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;592;3908.537,2003.564;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;985;3632.571,2690.153;Inherit;False;981;Hardmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;979;10016.19,4569.448;Inherit;True;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;927;10032.78,4284.586;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;982;10328.25,4359.777;Inherit;False;Gradmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;984;3585.901,2247.307;Inherit;False;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;949;3507.482,1837.432;Inherit;False;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1123;9745.408,3893.65;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;981;0;1146;0
WireConnection;887;0;900;0
WireConnection;903;0;897;0
WireConnection;900;0;895;0
WireConnection;900;1;901;0
WireConnection;866;1;876;0
WireConnection;1019;0;887;0
WireConnection;1021;0;1019;0
WireConnection;1039;0;957;0
WireConnection;1039;1;1020;0
WireConnection;1039;2;1040;0
WireConnection;1032;0;1039;0
WireConnection;1067;0;1065;0
WireConnection;1067;1;1068;0
WireConnection;1068;0;1032;0
WireConnection;929;0;927;0
WireConnection;1028;0;958;0
WireConnection;829;0;818;0
WireConnection;829;1;822;0
WireConnection;830;0;829;0
WireConnection;816;0;830;0
WireConnection;816;1;822;0
WireConnection;857;0;816;0
WireConnection;813;0;561;0
WireConnection;822;0;820;0
WireConnection;820;0;811;0
WireConnection;820;1;827;0
WireConnection;811;0;814;0
WireConnection;827;0;821;0
WireConnection;855;0;813;0
WireConnection;855;1;813;1
WireConnection;855;2;813;2
WireConnection;831;0;857;0
WireConnection;844;0;822;0
WireConnection;911;0;1077;0
WireConnection;1076;0;855;0
WireConnection;1077;0;1076;0
WireConnection;716;0;1150;0
WireConnection;465;0;464;0
WireConnection;794;0;703;0
WireConnection;792;0;663;0
WireConnection;733;0;592;0
WireConnection;691;0;733;0
WireConnection;690;0;691;0
WireConnection;470;0;597;0
WireConnection;793;0;470;0
WireConnection;781;0;734;0
WireConnection;700;0;774;0
WireConnection;700;1;772;0
WireConnection;698;0;697;0
WireConnection;698;1;862;0
WireConnection;780;0;768;0
WireConnection;768;0;564;0
WireConnection;768;1;773;0
WireConnection;734;0;747;0
WireConnection;734;1;735;0
WireConnection;734;2;693;0
WireConnection;744;0;724;0
WireConnection;914;0;771;0
WireConnection;663;0;793;0
WireConnection;466;0;984;0
WireConnection;466;1;470;0
WireConnection;819;0;610;0
WireConnection;771;0;565;0
WireConnection;874;0;697;4
WireConnection;800;0;862;0
WireConnection;775;0;914;0
WireConnection;862;0;694;0
WireConnection;948;0;567;4
WireConnection;948;1;949;0
WireConnection;774;0;698;0
WireConnection;774;1;775;0
WireConnection;986;0;1011;0
WireConnection;986;1;610;0
WireConnection;773;0;862;0
WireConnection;899;0;735;0
WireConnection;746;0;743;0
WireConnection;547;0;780;0
WireConnection;547;1;700;0
WireConnection;747;0;745;0
WireConnection;745;0;746;0
WireConnection;553;0;740;0
WireConnection;553;1;794;0
WireConnection;740;0;782;0
WireConnection;782;0;994;0
WireConnection;782;1;1052;0
WireConnection;782;2;1054;0
WireConnection;642;0;555;0
WireConnection;642;1;558;0
WireConnection;555;0;553;0
WireConnection;860;0;642;0
WireConnection;556;0;555;0
WireConnection;556;1;792;0
WireConnection;840;0;644;0
WireConnection;841;0;643;1
WireConnection;841;1;643;2
WireConnection;841;2;643;3
WireConnection;841;3;843;0
WireConnection;843;0;643;4
WireConnection;843;1;556;0
WireConnection;843;2;842;0
WireConnection;1057;0;1063;0
WireConnection;1057;1;644;0
WireConnection;564;0;565;0
WireConnection;564;1;950;0
WireConnection;950;0;567;1
WireConnection;950;1;567;2
WireConnection;950;2;567;3
WireConnection;950;3;1009;0
WireConnection;1009;0;1010;0
WireConnection;1069;0;567;4
WireConnection;1063;0;1061;0
WireConnection;641;0;558;0
WireConnection;1052;0;1049;0
WireConnection;1052;1;1053;0
WireConnection;1051;0;1048;0
WireConnection;1051;1;1053;0
WireConnection;1048;0;1049;0
WireConnection;1048;1;1050;0
WireConnection;1045;0;1043;0
WireConnection;1043;0;1042;0
WireConnection;1041;0;995;0
WireConnection;1041;1;1045;0
WireConnection;1054;0;1051;0
WireConnection;703;0;641;0
WireConnection;859;0;986;0
WireConnection;1073;0;1081;0
WireConnection;1073;1;1080;0
WireConnection;966;0;964;1
WireConnection;965;0;964;1
WireConnection;965;1;966;0
WireConnection;969;0;968;0
WireConnection;970;0;964;2
WireConnection;971;0;964;2
WireConnection;971;1;970;0
WireConnection;972;0;971;0
WireConnection;973;0;972;0
WireConnection;976;0;974;0
WireConnection;974;0;969;0
WireConnection;974;1;973;0
WireConnection;968;0;965;0
WireConnection;989;0;976;0
WireConnection;1079;0;1075;1
WireConnection;1080;0;1079;0
WireConnection;1078;0;989;0
WireConnection;1081;0;1078;0
WireConnection;1070;0;1067;0
WireConnection;1070;1;1071;0
WireConnection;1066;0;1070;0
WireConnection;901;0;903;0
WireConnection;715;0;716;0
WireConnection;715;1;716;1
WireConnection;715;2;716;2
WireConnection;715;3;1066;0
WireConnection;1097;0;984;0
WireConnection;1097;1;1096;0
WireConnection;1088;0;1087;0
WireConnection;1088;1;1089;2
WireConnection;1094;0;1099;0
WireConnection;1100;0;1085;2
WireConnection;1091;0;1085;2
WireConnection;1085;1;1088;0
WireConnection;1095;0;1099;0
WireConnection;1101;0;1099;0
WireConnection;1099;0;1091;0
WireConnection;1099;1;1102;0
WireConnection;1102;0;1089;4
WireConnection;983;0;940;0
WireConnection;983;1;1047;0
WireConnection;1110;0;1111;0
WireConnection;1114;0;1112;3
WireConnection;1115;0;1113;0
WireConnection;1115;4;1114;0
WireConnection;1115;5;1110;0
WireConnection;921;1;924;0
WireConnection;845;0;840;3
WireConnection;560;0;911;0
WireConnection;560;1;715;0
WireConnection;814;0;813;0
WireConnection;1108;0;919;0
WireConnection;919;0;924;0
WireConnection;942;0;1109;0
WireConnection;942;1;983;0
WireConnection;1020;0;958;0
WireConnection;1020;1;1028;0
WireConnection;868;0;866;0
WireConnection;868;1;870;0
WireConnection;895;0;868;0
WireConnection;895;1;902;0
WireConnection;924;0;1144;0
WireConnection;924;1;1144;1
WireConnection;1107;0;1103;3
WireConnection;563;0;985;0
WireConnection;1145;0;563;0
WireConnection;467;0;1145;0
WireConnection;464;0;466;0
WireConnection;464;1;467;0
WireConnection;610;0;465;0
WireConnection;610;1;1145;0
WireConnection;980;0;979;0
WireConnection;1146;0;980;0
WireConnection;975;0;921;1
WireConnection;975;1;1073;0
WireConnection;1116;0;1143;0
WireConnection;1116;1;1143;1
WireConnection;994;0;668;2
WireConnection;994;1;1041;0
WireConnection;644;0;860;0
WireConnection;644;1;841;0
WireConnection;559;0;1057;0
WireConnection;1061;1;1056;0
WireConnection;668;1;1116;0
WireConnection;714;0;834;0
WireConnection;834;0;560;0
WireConnection;1150;0;859;0
WireConnection;1150;1;1151;0
WireConnection;870;0;864;0
WireConnection;897;0;870;0
WireConnection;1027;0;1003;0
WireConnection;1027;1;1123;0
WireConnection;958;0;957;0
WireConnection;958;1;960;0
WireConnection;1011;0;780;0
WireConnection;1011;1;700;0
WireConnection;597;0;724;0
WireConnection;724;0;596;4
WireConnection;724;1;480;0
WireConnection;772;0;771;0
WireConnection;694;0;781;0
WireConnection;1010;0;948;0
WireConnection;1010;1;693;0
WireConnection;799;0;948;0
WireConnection;592;0;984;0
WireConnection;979;1;921;1
WireConnection;927;0;921;1
WireConnection;982;0;927;0
WireConnection;1123;0;1003;0
WireConnection;1123;1;960;0
ASEEND*/
//CHKSM=54DDDBE7B64086B82116642F393A861B00DDA3DD