// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_waterfall"
{
	Properties
	{
		_DeformNoise("DeformNoise", 2D) = "white" {}
		_RippleNoise("RippleNoise", 2D) = "white" {}
		[Toggle]_Invert_Detail("Invert_Detail", Float) = 1
		_RippleIntensity("RippleIntensity", Range( -3 , 3)) = 0.7030736
		[HDR]_BaseCol("BaseCol", Color) = (0.5849056,0.3669455,0.5450754,0)
		[HDR]_Light("Light", Color) = (0.3467041,0.4396572,1,1)
		[HDR]_DetailColor("DetailColor", Color) = (0.3037113,0.4441899,0.8584906,0)
		_Panner_Main_U("Panner_Main_U", Float) = 0
		_Panner_Main_V("Panner_Main_V", Float) = 0.2
		_Panner_Ripple_U("Panner_Ripple_U", Float) = 0
		_Panner_Shape_U("Panner_Shape_U", Float) = 0
		_Panner_Ripple_V("Panner_Ripple_V", Float) = 0.5
		_Panner_Shape_V("Panner_Shape_V", Float) = 0.5
		_Texture0("Texture 0", 2D) = "white" {}
		_HighlightAmount("HighlightAmount", Range( 0 , 1)) = 1
		_HighlightSharpness("HighlightSharpness", Range( 0 , 1)) = 0.7679125
		_Translucency("Translucency", Range( -1 , 1)) = 0.1086956
		_Highlight_Top_Breakup("Highlight_Top_Breakup", Range( 0 , 1)) = 0
		_DeformAmount("DeformAmount", Range( 0 , 1)) = 0
		_Emissive("Emissive", Range( 0 , 1)) = 0
		_ShadingMaxThreshold("ShadingMaxThreshold", Range( 0 , 1)) = 0
		_ShadingMinThreshold("ShadingMinThreshold", Range( -0.2 , 1)) = 0

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
			#include "UnityStandardBRDF.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
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
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _DeformNoise;
			uniform float _Panner_Shape_U;
			uniform float _Panner_Shape_V;
			uniform float4 _DeformNoise_ST;
			uniform float _DeformAmount;
			uniform float4 _Light;
			uniform sampler2D _RippleNoise;
			uniform float _Panner_Ripple_U;
			uniform float _Panner_Ripple_V;
			uniform float4 _RippleNoise_ST;
			uniform float _RippleIntensity;
			uniform float _Translucency;
			uniform float _HighlightAmount;
			uniform float _Highlight_Top_Breakup;
			uniform float _HighlightSharpness;
			uniform float4 _BaseCol;
			uniform float _Invert_Detail;
			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float _Panner_Main_U;
			uniform float _Panner_Main_V;
			uniform float4 _DetailColor;
			uniform float _ShadingMinThreshold;
			uniform float _ShadingMaxThreshold;
			uniform float _Emissive;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult1040 = (float2(_Panner_Shape_U , _Panner_Shape_V));
				float2 texCoord1036 = v.ase_texcoord.xy * _DeformNoise_ST.xy + _DeformNoise_ST.zw;
				float2 panner1037 = ( 1.0 * _Time.y * appendResult1040 + texCoord1036);
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float2 texCoord2_g6 = v.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 vertexToFrag10_g6 = ( ( texCoord2_g6 * (unity_LightmapST).xy ) + (unity_LightmapST).zw );
				o.ase_texcoord1.zw = vertexToFrag10_g6;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( tex2Dlod( _DeformNoise, float4( panner1037, 0, 0.0) ).r + v.ase_normal ) * _DeformAmount );
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
				float2 appendResult978 = (float2(_Panner_Ripple_U , _Panner_Ripple_V));
				float2 texCoord975 = i.ase_texcoord1.xy * _RippleNoise_ST.xy + _RippleNoise_ST.zw;
				float2 panner979 = ( 1.0 * _Time.y * appendResult978 + texCoord975);
				float Ripple935 = saturate( ( tex2D( _RippleNoise, panner979 ).r * _RippleIntensity ) );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = Unity_SafeNormalize( ase_worldViewDir );
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float dotResult984 = dot( ase_worldViewDir , ase_worldNormal );
				float temp_output_986_0 = ( ( dotResult984 - ase_worldNormal.y ) - _Translucency );
				float temp_output_991_0 = ( ( ( Ripple935 - temp_output_986_0 ) + ( 1.0 - temp_output_986_0 ) ) * _HighlightAmount * ( ( 1.0 - ( temp_output_986_0 * ( 1.0 - Ripple935 ) * -1.1 ) ) + ( 1.0 - _Highlight_Top_Breakup ) ) );
				float temp_output_3_0_g5 = ( 1.0 - temp_output_991_0 );
				float lerpResult993 = lerp( temp_output_991_0 , ( 1.0 - saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) ) , _HighlightSharpness);
				float2 texCoord936 = i.ase_texcoord1.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float2 panner953 = ( 1.0 * _Time.y * float2( 0,0 ) + texCoord936);
				float2 appendResult958 = (float2(_Panner_Main_U , _Panner_Main_V));
				float2 texCoord937 = i.ase_texcoord1.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float2 panner954 = ( 1.0 * _Time.y * appendResult958 + ( texCoord937 + Ripple935 ));
				float2 lerpResult938 = lerp( panner953 , panner954 , 0.414084);
				float4 tex2DNode960 = tex2D( _Texture0, lerpResult938 );
				float4 temp_output_932_0 = ( (( _Invert_Detail )?( ( 1.0 - tex2DNode960.g ) ):( tex2DNode960.g )) * _DetailColor );
				float4 blendOpSrc952 = saturate( _BaseCol );
				float4 blendOpDest952 = temp_output_932_0;
				float4 temp_cast_0 = (lerpResult993).xxxx;
				float4 temp_output_999_0 = ( saturate( ( _Light * lerpResult993 ) ) + saturate( ( saturate( ( saturate( ( 1.0 - ( 1.0 - blendOpSrc952 ) * ( 1.0 - blendOpDest952 ) ) )) ) - temp_cast_0 ) ) );
				float3 temp_cast_1 = (_ShadingMinThreshold).xxx;
				float3 temp_cast_2 = (_ShadingMaxThreshold).xxx;
				float2 vertexToFrag10_g6 = i.ase_texcoord1.zw;
				float4 tex2DNode7_g6 = UNITY_SAMPLE_TEX2D( unity_Lightmap, vertexToFrag10_g6 );
				float3 decodeLightMap6_g6 = DecodeLightmap(tex2DNode7_g6);
				float3 smoothstepResult1066 = smoothstep( temp_cast_1 , temp_cast_2 , decodeLightMap6_g6);
				
				
				finalColor = ( ( temp_output_999_0 * float4( smoothstepResult1066 , 0.0 ) ) + ( temp_output_999_0 * _Emissive ) );
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;932;5922.811,3181.429;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;948;5679.811,3053.429;Inherit;False;Property;_Invert_Detail;Invert_Detail;4;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;949;5530.811,3139.429;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;954;4665.28,3066.88;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;944;4191.208,3515.646;Inherit;False;935;Ripple;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;938;4950.811,2986.429;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;945;4481.234,3321.997;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;953;4653.4,2935.064;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;941;5823.515,3743.75;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;933;5658.515,3838.75;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;935;5971.258,3739.021;Inherit;False;Ripple;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;942;4672.648,3233.848;Inherit;False;Constant;_RippleIntensity_Main;RippleIntensity_Main;1;0;Create;True;0;0;0;False;0;False;0.414084;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;956;4177.955,3119.154;Inherit;False;Property;_Panner_Main_U;Panner_Main_U;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;957;4180.955,3186.154;Inherit;False;Property;_Panner_Main_V;Panner_Main_V;11;0;Create;True;0;0;0;False;0;False;0.2;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;934;5326.811,4015.429;Inherit;False;Property;_RippleIntensity;RippleIntensity;6;0;Create;True;0;0;0;False;0;False;0.7030736;1.02;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;936;4214.436,2933.308;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;958;4413.957,3142.552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;973;3867.754,2952.154;Inherit;False;959;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;963;4160.796,4235.974;Inherit;False;935;Ripple;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;967;4920.399,3706.757;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;968;4450.822,4042.325;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;970;4635.399,3952.757;Inherit;False;Property;_RippleAmount;RippleAmount;5;0;Create;True;0;0;0;False;0;False;0.2708185;0.333;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;971;4184.024,3652.636;Inherit;False;0;959;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;969;4622.988,3655.392;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;962;4138.579,4028.203;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;965;4150.543,3906.482;Inherit;False;Property;_Panner_Detail_V;Panner_Detail_V;15;0;Create;True;0;0;0;False;0;False;0.5;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;966;4146.543,3839.482;Inherit;False;Property;_Panner_Detail_U;Panner_Detail_U;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;964;4409.543,3917.482;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;961;4634.868,3787.208;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;931;5306.811,3499.429;Inherit;False;Property;_DetailColor;DetailColor;9;1;[HDR];Create;True;0;0;0;False;0;False;0.3037113,0.4441899,0.8584906,0;0.8490566,0.8490566,0.8490566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;929;5284.675,2425.878;Inherit;False;Property;_BaseCol;BaseCol;7;1;[HDR];Create;True;0;0;0;False;0;False;0.5849056,0.3669455,0.5450754,0;0.7247686,0.7499804,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;980;5980.536,2657.698;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;981;6110.536,3329.801;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;982;4738.167,1048.199;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;984;4944.647,1234.357;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;985;5065.352,1340.324;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;986;5306.992,1407.897;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.61;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;994;6013.214,2175.488;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;996;6369.075,1948.567;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;1001;7071.482,2702.5;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;990;5147.107,1837.839;Inherit;False;Property;_HighlightAmount;HighlightAmount;19;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;992;5082.834,2069.503;Inherit;False;Property;_HighlightSharpness;HighlightSharpness;20;0;Create;True;0;0;0;False;0;False;0.7679125;0.847;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1006;6528.636,2810.996;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1000;6766.767,2647.598;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;998;6614.217,2154.404;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1004;5490.77,1719.515;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;987;5522.954,1144;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;989;4914.468,1511.986;Inherit;False;Property;_Translucency;Translucency;21;0;Create;True;0;0;0;False;0;False;0.1086956;-0.123;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;993;6211.383,2042.994;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;997;6352.261,1468.578;Inherit;False;Property;_Light;Light;8;1;[HDR];Create;True;0;0;0;False;0;False;0.3467041,0.4396572,1,1;0.6167675,0.6442183,0.7924528,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;995;5777.005,2143.342;Inherit;True;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1007;5296.934,1662.532;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1002;4791.77,1731.515;Inherit;True;935;Ripple;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1005;5731.77,1712.515;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1027;5562.934,1575.532;Inherit;False;Constant;_Float0;Float 0;18;0;Create;True;0;0;0;False;0;False;-1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1023;5745.934,1355.532;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1026;5982.934,1410.532;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;991;6029.448,1877.713;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0.14;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1028;6138.934,1654.532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1030;5974.934,1726.532;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1029;5726.934,1614.532;Inherit;False;Property;_Highlight_Top_Breakup;Highlight_Top_Breakup;22;0;Create;True;0;0;0;False;0;False;0;0.41;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;983;4522.146,1258.964;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;959;4828.955,2621.154;Inherit;True;Property;_Texture0;Texture 0;18;0;Create;True;0;0;0;False;0;False;7cf6afe4105669349bd222f33ba5795d;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;1032;6755.83,3995.45;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;1033;6538.7,4410.83;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;943;5272.664,3768.33;Inherit;True;Property;_RippleNoise;RippleNoise;3;0;Create;True;0;0;0;False;0;False;-1;138dff2decdf168479497897cb336dd6;21b46c6e6bfb16e4abfced00ad9152cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;975;4176,4304;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;979;4656,4384;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;977;4160,4432;Inherit;False;Property;_Panner_Ripple_U;Panner_Ripple_U;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;976;4160,4496;Inherit;False;Property;_Panner_Ripple_V;Panner_Ripple_V;16;0;Create;True;0;0;0;False;0;False;0.5;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;978;4432,4512;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1042;6801.839,4217.927;Inherit;False;Property;_DeformAmount;DeformAmount;23;0;Create;True;0;0;0;False;0;False;0;0.075;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;960;5184.955,3172.154;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;7cf6afe4105669349bd222f33ba5795d;7cf6afe4105669349bd222f33ba5795d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;937;4220.991,3299.875;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;1037;6152.321,4234.357;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1036;5695.321,4297.357;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1039;5509.059,4707.763;Inherit;False;Property;_Panner_Shape_V;Panner_Shape_V;17;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1040;5751.059,4468.763;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1041;7179.737,3996.844;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1038;5509.059,4643.763;Inherit;False;Property;_Panner_Shape_U;Panner_Shape_U;14;0;Create;True;0;0;0;False;0;False;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;974;3856,4256;Inherit;False;943;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;972;3835.655,3667.154;Inherit;False;959;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;1035;5390.053,4286.341;Inherit;False;1034;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;1034;6351.557,4098.066;Inherit;True;Property;_DeformNoise;DeformNoise;2;0;Create;True;0;0;0;False;0;False;-1;138dff2decdf168479497897cb336dd6;204cd928e761305469a2ef1af3831454;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;952;6379.706,2972.728;Inherit;True;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1047;7520.698,3664.265;Inherit;False;Property;_Emissive;Emissive;24;0;Create;True;0;0;0;False;0;False;0;0.342;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1046;7832.905,3537.337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1068;7756.097,3312.094;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1043;7822.966,3330.902;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1069;7618.818,3538.3;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1074;7652.836,2555.698;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1070;7691.584,2641.426;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1073;7538.226,2676.881;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1072;7562.725,3469.51;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1066;7306.646,3355.339;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.1,0.1,0.1;False;2;FLOAT3;0.2,0.2,0.2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;999;7273.894,2465.764;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1076;7997.338,3516.409;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1075;8270.205,3630.057;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_waterfall;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.FunctionNode;1044;6980.048,3208.468;Inherit;False;FetchLightmapValue;0;;6;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1077;6969.275,3341.108;Inherit;False;Property;_ShadingMinThreshold;ShadingMinThreshold;26;0;Create;True;0;0;0;False;0;False;0;-0.053;-0.2;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1078;6900.275,3440.108;Inherit;False;Property;_ShadingMaxThreshold;ShadingMaxThreshold;25;0;Create;True;0;0;0;False;0;False;0;0.078;0;1;0;1;FLOAT;0
WireConnection;932;0;948;0
WireConnection;932;1;931;0
WireConnection;948;0;960;2
WireConnection;948;1;949;0
WireConnection;949;0;960;2
WireConnection;954;0;945;0
WireConnection;954;2;958;0
WireConnection;938;0;953;0
WireConnection;938;1;954;0
WireConnection;938;2;942;0
WireConnection;945;0;937;0
WireConnection;945;1;944;0
WireConnection;953;0;936;0
WireConnection;941;0;933;0
WireConnection;933;0;943;1
WireConnection;933;1;934;0
WireConnection;935;0;941;0
WireConnection;936;0;973;0
WireConnection;936;1;973;1
WireConnection;958;0;956;0
WireConnection;958;1;957;0
WireConnection;967;0;969;0
WireConnection;967;1;961;0
WireConnection;967;2;970;0
WireConnection;968;0;962;0
WireConnection;968;1;963;0
WireConnection;971;0;972;0
WireConnection;971;1;972;1
WireConnection;969;0;971;0
WireConnection;962;0;972;0
WireConnection;962;1;972;1
WireConnection;964;0;966;0
WireConnection;964;1;965;0
WireConnection;961;0;968;0
WireConnection;961;2;964;0
WireConnection;980;0;929;0
WireConnection;981;0;932;0
WireConnection;984;0;982;0
WireConnection;984;1;983;0
WireConnection;985;0;984;0
WireConnection;985;1;983;2
WireConnection;986;0;985;0
WireConnection;986;1;989;0
WireConnection;994;0;995;0
WireConnection;996;0;997;0
WireConnection;996;1;993;0
WireConnection;1001;0;1000;0
WireConnection;1006;0;952;0
WireConnection;1000;0;1006;0
WireConnection;1000;1;993;0
WireConnection;998;0;996;0
WireConnection;1004;0;1002;0
WireConnection;1004;1;986;0
WireConnection;987;0;986;0
WireConnection;993;0;991;0
WireConnection;993;1;994;0
WireConnection;993;2;992;0
WireConnection;995;1;991;0
WireConnection;1007;0;1002;0
WireConnection;1005;0;1004;0
WireConnection;1005;1;987;0
WireConnection;1023;0;986;0
WireConnection;1023;1;1007;0
WireConnection;1023;2;1027;0
WireConnection;1026;0;1023;0
WireConnection;991;0;1005;0
WireConnection;991;1;990;0
WireConnection;991;2;1028;0
WireConnection;1028;0;1026;0
WireConnection;1028;1;1030;0
WireConnection;1030;0;1029;0
WireConnection;1032;0;1034;1
WireConnection;1032;1;1033;0
WireConnection;943;1;979;0
WireConnection;975;0;974;0
WireConnection;975;1;974;1
WireConnection;979;0;975;0
WireConnection;979;2;978;0
WireConnection;978;0;977;0
WireConnection;978;1;976;0
WireConnection;960;0;959;0
WireConnection;960;1;938;0
WireConnection;937;0;973;0
WireConnection;937;1;973;1
WireConnection;1037;0;1036;0
WireConnection;1037;2;1040;0
WireConnection;1036;0;1035;0
WireConnection;1036;1;1035;1
WireConnection;1040;0;1038;0
WireConnection;1040;1;1039;0
WireConnection;1041;0;1032;0
WireConnection;1041;1;1042;0
WireConnection;1034;1;1037;0
WireConnection;952;0;980;0
WireConnection;952;1;932;0
WireConnection;1046;0;1069;0
WireConnection;1046;1;1047;0
WireConnection;1068;0;1070;0
WireConnection;1043;0;1068;0
WireConnection;1043;1;1066;0
WireConnection;1069;0;1072;0
WireConnection;1074;0;999;0
WireConnection;1070;0;1074;0
WireConnection;1073;0;999;0
WireConnection;1072;0;1073;0
WireConnection;1066;0;1044;0
WireConnection;1066;1;1077;0
WireConnection;1066;2;1078;0
WireConnection;999;0;998;0
WireConnection;999;1;1001;0
WireConnection;1076;0;1043;0
WireConnection;1076;1;1046;0
WireConnection;1075;0;1076;0
WireConnection;1075;1;1041;0
ASEEND*/
//CHKSM=F00946AA007BF5A09C0897F0B01F06C82BD36ABF