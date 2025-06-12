// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_playerhealth_screenbleed_mult"
{
	Properties
	{
		_Health("Health", Range( 0 , 1)) = 0.98
		[HDR]_BaseColor("BaseColor", Color) = (0.2075472,0,0,1)
		_Translucency("Translucency", Range( 0 , 1)) = 0.3274422
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_LucencyMult("LucencyMult", Range( 0 , 2)) = 0
		_Brightness("Brightness", Range( 0.1 , 2)) = 0.1
		_Thicken("Thicken", Range( 0 , 8)) = 0
		_Fade("Fade", Range( 0 , 1)) = 0
		_MaxCoverAdjust("MaxCoverAdjust", Range( 0 , 1)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend DstColor Zero
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest Always
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _MaxCoverAdjust;
			uniform sampler2D _TextureSample0;
			uniform half4 _TextureSample0_ST;
			uniform half4 _BaseColor;
			uniform half _Health;
			uniform half _Translucency;
			uniform half _Brightness;
			uniform half _Thicken;
			uniform half _LucencyMult;
			uniform half _Fade;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

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
				half2 texCoord924 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				half4 tex2DNode921 = tex2D( _TextureSample0, texCoord924 );
				half temp_output_3_0_g5 = ( ( 1.0 - _MaxCoverAdjust ) - tex2DNode921.r );
				half Hardmask981 = saturate( ( 1.0 - saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) ) );
				half Gradmask982 = saturate( tex2DNode921.r );
				half temp_output_948_0 = ( _BaseColor.a * Gradmask982 );
				half Translucency690 = ( 1.0 - Gradmask982 );
				half4 appendResult950 = (half4(_BaseColor.r , _BaseColor.g , _BaseColor.b , saturate( ( temp_output_948_0 - Translucency690 ) )));
				half temp_output_724_0 = ( _Health * 0.65 );
				half Erodeval744 = temp_output_724_0;
				half clampResult747 = clamp( ( ( 1.0 - Erodeval744 ) * 3.0 ) , 0.0 , 1.0 );
				half temp_output_862_0 = saturate( saturate( ( clampResult747 * _Translucency * Translucency690 ) ) );
				half4 temp_cast_0 = (temp_output_862_0).xxxx;
				half A563 = Hardmask981;
				half temp_output_465_0 = saturate( ( ( Gradmask982 - saturate( ( 1.0 - temp_output_724_0 ) ) ) / ( 1.0 - saturate( A563 ) ) ) );
				half temp_output_1155_0 = ( ( _Brightness + ( ( 1.0 - Erodeval744 ) * 2.0 ) ) - ( ( 1.0 - Translucency690 ) * ( Erodeval744 * _Thicken ) ) );
				half BaseColAlphaUnmasked1069 = _BaseColor.a;
				half Erosion819 = temp_output_465_0;
				half temp_output_958_0 = ( Erosion819 * _LucencyMult );
				half TranslucencySlider899 = _Translucency;
				half lerpResult1039 = lerp( Erosion819 , temp_output_958_0 , TranslucencySlider899);
				half temp_output_1152_0 = ( 1.0 - saturate( ( BaseColAlphaUnmasked1069 - ( 1.0 - saturate( lerpResult1039 ) ) ) ) );
				half4 break716 = ( ( saturate( ( saturate( ( ( Hardmask981 * appendResult950 ) - temp_cast_0 ) ) * ( temp_output_465_0 + Erodeval744 ) ) ) * saturate( temp_output_1155_0 ) ) + temp_output_1152_0 );
				half temp_output_1221_0 = saturate( _Fade );
				half4 appendResult715 = (half4(( break716.x - temp_output_1221_0 ) , ( break716.y - temp_output_1221_0 ) , ( break716.z - temp_output_1221_0 ) , 0.32));
				
				
				finalColor = saturate( ( appendResult715 * ( 1.0 - _Fade ) ) );
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
Node;AmplifyShaderEditor.LerpOp;1039;10787.24,3457.044;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;957;9486.078,3452.327;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1032;11069.22,3528.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;781;6242.883,880.1812;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;734;6039.198,884.877;Inherit;True;3;3;0;FLOAT;1.91;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;862;6960.01,885.409;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;899;5691.6,995.1051;Inherit;False;TranslucencySlider;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;735;5318.91,900.053;Inherit;False;Property;_Translucency;Translucency;2;0;Create;True;0;0;0;False;0;False;0.3274422;0.843;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;746;5337.867,739.7811;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;5113.819,737.3331;Inherit;True;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;747;5631.931,731.8912;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;745;5496.368,738.4581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;950;6974.427,1614.39;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;693;5700.667,1884.415;Inherit;True;690;Translucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1009;6781.707,1715.712;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;799;6552.686,1727.896;Inherit;False;BaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;948;6282.441,1703.943;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1069;6336.551,1592.83;Inherit;False;BaseColAlphaUnmasked;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;565;6972.285,1483.284;Inherit;False;981;Hardmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;800;7258.648,906.9065;Inherit;False;LucencyAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;768;7422.588,1481.599;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;7205.911,1529.091;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1150;9078.165,3339.005;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1164;8906.26,3448.837;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1166;8930.786,3693.85;Inherit;False;Lumpy;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1028;10250.96,3778.022;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;960;9739.179,3737.229;Inherit;False;Property;_LucencyMult;LucencyMult;4;0;Create;True;0;0;0;False;0;False;0;1.097;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1155;8731.926,3453.48;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1185;8507.803,3374.929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1186;8165.803,3425.929;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1182;8286.803,3643.929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1162;8280.959,3544.513;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1159;8479.875,3571.043;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1068;11251.63,3815.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1065;11388.31,3721.061;Inherit;False;1069;BaseColAlphaUnmasked;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1020;10496.13,3581.719;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;465;7618.768,2603.26;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;464;7393.628,2600.758;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;470;6763.778,2504.59;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;597;6644.18,2592.075;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;984;6725.502,2348.082;Inherit;False;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;744;6676.076,2224.935;Inherit;False;Erodeval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;691;7070.873,2240.347;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;563;6739.256,2927.006;Inherit;True;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1145;6970.229,2923.541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;467;7151.849,2797.862;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;466;7103.9,2469.647;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1190;8837.259,3235.459;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;780;7672.732,1479.684;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;1189;7892.526,2200.162;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;986;8181.34,2571.143;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;859;8607.649,2925.739;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;1191;8440.563,2810.228;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;690;7268.967,2235.78;Inherit;False;Translucency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;6183.584,2490.038;Inherit;False;Property;_Health;Health;0;0;Create;True;0;0;0;False;0;False;0.98;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;819;7840.039,2621.808;Inherit;False;Erosion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1193;7452.874,3103.658;Inherit;False;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1192;7997.578,2836.758;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1066;11902.89,3609.266;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;567;6067.059,1293.646;Inherit;False;Property;_BaseColor;BaseColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0.2075472,0,0,1;1,0.3673308,0.3537736,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1200;6535.378,1366.486;Inherit;False;Col;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1201;11953.12,3957.8;Inherit;False;1200;Col;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1195;11777.28,4254.437;Inherit;False;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1156;7739.188,3358.984;Inherit;True;690;Translucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1183;7772.308,3564.129;Inherit;False;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1010;6551.031,1885.756;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;949;6001.519,1753.718;Inherit;False;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1067;11679.76,3821.391;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1152;12075.03,3592.637;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1209;12681.07,3894.007;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1199;12309.55,3785.102;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1197;12078.5,4167.917;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;958;10035.29,3563.404;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1040;10480.49,3827.656;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;560;12408.31,3346.906;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;716;12694.29,3254.527;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;715;13264.01,3245.842;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.32;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1238;13027.57,3437.174;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;834;13801.99,3277.861;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1239;13561.38,3034.035;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1208;11743.34,3029.135;Inherit;False;Property;_Fade;Fade;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1220;12341.63,2934.714;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1180;14118.66,3280.682;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_playerhealth_screenbleed_mult;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;6;2;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;True;True;False;0;False;;255;False;;255;False;;0;False;;2;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;7;False;;True;True;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.PowerNode;1219;12186.83,3191.64;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1161;7808.75,3670.743;Inherit;False;Property;_Thicken;Thicken;6;0;Create;True;0;0;0;False;0;False;0;7.18;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1151;8010.479,3328.439;Inherit;False;Property;_Brightness;Brightness;5;0;Create;True;0;0;0;False;0;False;0.1;2;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;985;6516.08,2928.109;Inherit;False;981;Hardmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;980;9387.088,1231.865;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1146;9576.258,1305.84;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;927;9108.748,826.7826;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;981;9743.658,1229.659;Inherit;False;Hardmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;921;8671.995,946.5496;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;a659af092a5aba04ea98e5209f876ec9;a659af092a5aba04ea98e5209f876ec9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;924;8438.25,970.8444;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;1144;8166.284,996.3815;Inherit;False;921;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;982;9713.514,922.2669;Inherit;False;Gradmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;724;6481.849,2497.95;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0.65;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1184;8306.803,3427.929;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;979;9096.158,1120.646;Inherit;True;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1240;8447.893,1342.256;Inherit;False;Property;_MaxCoverAdjust;MaxCoverAdjust;8;0;Create;True;0;0;0;False;0;False;0;0.573;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1241;8905.893,1458.256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1221;12650.77,3082.711;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1237;13012.77,3349.672;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1242;13009.67,3181.581;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;1039;0;957;0
WireConnection;1039;1;958;0
WireConnection;1039;2;1040;0
WireConnection;1032;0;1039;0
WireConnection;781;0;734;0
WireConnection;734;0;747;0
WireConnection;734;1;735;0
WireConnection;734;2;693;0
WireConnection;862;0;781;0
WireConnection;899;0;735;0
WireConnection;746;0;743;0
WireConnection;747;0;745;0
WireConnection;745;0;746;0
WireConnection;950;0;567;1
WireConnection;950;1;567;2
WireConnection;950;2;567;3
WireConnection;950;3;1009;0
WireConnection;1009;0;1010;0
WireConnection;799;0;948;0
WireConnection;948;0;567;4
WireConnection;948;1;949;0
WireConnection;1069;0;567;4
WireConnection;800;0;862;0
WireConnection;768;0;564;0
WireConnection;768;1;862;0
WireConnection;564;0;565;0
WireConnection;564;1;950;0
WireConnection;1150;0;1190;0
WireConnection;1150;1;1164;0
WireConnection;1164;0;1155;0
WireConnection;1166;0;1155;0
WireConnection;1028;0;960;0
WireConnection;1155;0;1185;0
WireConnection;1155;1;1159;0
WireConnection;1185;0;1151;0
WireConnection;1185;1;1184;0
WireConnection;1186;0;1183;0
WireConnection;1182;0;1183;0
WireConnection;1182;1;1161;0
WireConnection;1162;0;1156;0
WireConnection;1159;0;1162;0
WireConnection;1159;1;1182;0
WireConnection;1068;0;1032;0
WireConnection;1020;0;958;0
WireConnection;1020;1;1028;0
WireConnection;465;0;464;0
WireConnection;464;0;466;0
WireConnection;464;1;467;0
WireConnection;470;0;597;0
WireConnection;597;0;724;0
WireConnection;744;0;724;0
WireConnection;691;0;984;0
WireConnection;563;0;985;0
WireConnection;1145;0;563;0
WireConnection;467;0;1145;0
WireConnection;466;0;984;0
WireConnection;466;1;470;0
WireConnection;1190;0;859;0
WireConnection;780;0;768;0
WireConnection;1189;0;780;0
WireConnection;986;0;1189;0
WireConnection;986;1;1192;0
WireConnection;859;0;1191;0
WireConnection;1191;0;986;0
WireConnection;690;0;691;0
WireConnection;819;0;465;0
WireConnection;1192;0;465;0
WireConnection;1192;1;1193;0
WireConnection;1066;0;1067;0
WireConnection;1200;0;567;0
WireConnection;1010;0;948;0
WireConnection;1010;1;693;0
WireConnection;1067;0;1065;0
WireConnection;1067;1;1068;0
WireConnection;1152;0;1066;0
WireConnection;1209;0;1199;0
WireConnection;1199;0;1152;0
WireConnection;1199;1;1197;0
WireConnection;1197;0;1195;0
WireConnection;958;0;957;0
WireConnection;958;1;960;0
WireConnection;560;0;1150;0
WireConnection;560;1;1152;0
WireConnection;716;0;560;0
WireConnection;715;0;1242;0
WireConnection;715;1;1237;0
WireConnection;715;2;1238;0
WireConnection;1238;0;716;2
WireConnection;1238;1;1221;0
WireConnection;834;0;1239;0
WireConnection;1239;0;715;0
WireConnection;1239;1;1220;0
WireConnection;1220;0;1208;0
WireConnection;1180;0;834;0
WireConnection;1219;0;1208;0
WireConnection;980;0;979;0
WireConnection;1146;0;980;0
WireConnection;927;0;921;1
WireConnection;981;0;1146;0
WireConnection;921;1;924;0
WireConnection;924;0;1144;0
WireConnection;924;1;1144;1
WireConnection;982;0;927;0
WireConnection;724;0;480;0
WireConnection;1184;0;1186;0
WireConnection;979;1;921;1
WireConnection;979;2;1241;0
WireConnection;1241;0;1240;0
WireConnection;1221;0;1208;0
WireConnection;1237;0;716;1
WireConnection;1237;1;1221;0
WireConnection;1242;0;716;0
WireConnection;1242;1;1221;0
ASEEND*/
//CHKSM=C8E6FFC19CD08BA94D148B7373305BD3F8A41FA3