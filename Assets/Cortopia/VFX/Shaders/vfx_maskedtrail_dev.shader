// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_maskedtrail_dev"
{
	Properties
	{
		_Erode("Erode", Range( 0 , 0.98)) = 0.98
		_Spec("Spec", Range( 0 , 1)) = 1
		[HDR]_BaseColor("BaseColor", Color) = (1,0,0,1)
		[HDR]_Lucencycol("Lucencycol", Color) = (0.6509434,0,0.4581906,0.01960784)
		[HDR]_SpecColor("SpecColor", Color) = (27.3029,15.14408,1.858313,1)
		[Normal]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Translucency("Translucency", Range( 0 , 1)) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_LucencyMult("LucencyMult", Range( 0 , 3)) = 3
		_NormalMult("NormalMult", Range( 0 , 5)) = 1
		_SpecSharp("SpecSharp", Range( 1 , 10)) = 1
		_SeqSpeedFPS("SeqSpeedFPS", Range( 0 , 120)) = 0
		[Toggle]_GradMaskOrTexMask("GradMaskOrTexMask", Float) = 1
		_SilhouetteMask("SilhouetteMask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"
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
			uniform sampler2D _TextureSample0;
			uniform float _SeqSpeedFPS;
			uniform float _GradMaskOrTexMask;
			uniform sampler2D _SilhouetteMask;
			uniform float4 _SilhouetteMask_ST;
			uniform float _NormalMult;
			uniform float _Erode;
			uniform float _Spec;
			uniform float4 _SpecColor;
			uniform float4 _BaseColor;
			uniform float4 _Lucencycol;
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
				float2 texCoord670 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord924 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime923 = _Time.y * _SeqSpeedFPS;
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles919 = 5.0 * 5.0;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset919 = 1.0f / 5.0;
				float fbrowsoffset919 = 1.0f / 5.0;
				// Speed of animation
				float fbspeed919 = mulTime923 * 1.0;
				// UV Tiling (col and row offset)
				float2 fbtiling919 = float2(fbcolsoffset919, fbrowsoffset919);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex919 = round( fmod( fbspeed919 + 0.0, fbtotaltiles919) );
				fbcurrenttileindex919 += ( fbcurrenttileindex919 < 0) ? fbtotaltiles919 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox919 = round ( fmod ( fbcurrenttileindex919, 5.0 ) );
				// Multiply Offset X by coloffset
				float fboffsetx919 = fblinearindextox919 * fbcolsoffset919;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy919 = round( fmod( ( fbcurrenttileindex919 - fblinearindextox919 ) / 5.0, 5.0 ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy919 = (int)(5.0-1) - fblinearindextoy919;
				// Multiply Offset Y by rowoffset
				float fboffsety919 = fblinearindextoy919 * fbrowsoffset919;
				// UV Offset
				float2 fboffset919 = float2(fboffsetx919, fboffsety919);
				// Flipbook UV
				half2 fbuv919 = texCoord924 * fbtiling919 + fboffset919;
				// *** END Flipbook UV Animation vars ***
				float2 texCoord964 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult989 = smoothstep( 0.0 , 0.23 , pow( ( saturate( ( ( texCoord964.x * ( 1.0 - texCoord964.x ) ) * 4.0 ) ) * saturate( ( ( texCoord964.y * ( 1.0 - texCoord964.y ) ) * 4.0 ) ) ) , 2.32 ));
				float2 uv_SilhouetteMask = i.ase_texcoord1.xy * _SilhouetteMask_ST.xy + _SilhouetteMask_ST.zw;
				float temp_output_975_0 = ( tex2D( _TextureSample0, fbuv919 ).r * (( _GradMaskOrTexMask )?( tex2D( _SilhouetteMask, uv_SilhouetteMask ).r ):( smoothstepResult989 )) );
				float temp_output_927_0 = saturate( temp_output_975_0 );
				float Gradmask982 = temp_output_927_0;
				float temp_output_983_0 = ( Gradmask982 * 0.5 );
				float2 temp_cast_0 = (temp_output_983_0).xx;
				float2 lerpResult942 = lerp( texCoord670 , temp_cast_0 , float2( 0.4,0.4 ));
				float temp_output_724_0 = ( i.ase_color.a * _Erode );
				float Erodeval744 = temp_output_724_0;
				float clampResult1045 = clamp( ( Erodeval744 + 0.7 ) , 0.2 , 1.0 );
				float smoothstepResult782 = smoothstep( ( 0.07 * _SpecSharp ) , clampResult1054 , ( UnpackScaleNormal( tex2D( _TextureSample1, lerpResult942 ), 2.0 ).g * ( _NormalMult * clampResult1045 ) ));
				float temp_output_555_0 = saturate( ( saturate( smoothstepResult782 ) - ( ( 1.0 - _Spec ) + 0.23 ) ) );
				float temp_output_470_0 = saturate( ( 1.0 - temp_output_724_0 ) );
				float temp_output_3_0_g5 = ( 0.04 - temp_output_975_0 );
				float Hardmask981 = ( 1.0 - saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) );
				float A563 = Hardmask981;
				float temp_output_610_0 = ( saturate( ( ( Gradmask982 - temp_output_470_0 ) / ( 1.0 - A563 ) ) ) * A563 );
				float Erosion819 = temp_output_610_0;
				float4 appendResult841 = (float4(_SpecColor.r , _SpecColor.g , _SpecColor.b , ( _SpecColor.a * ( temp_output_555_0 / temp_output_470_0 ) * Erosion819 )));
				float4 temp_output_644_0 = ( saturate( ( temp_output_555_0 * _Spec ) ) * appendResult841 );
				float4 GradSpec559 = ( ( ( 1.0 - TranslucencySlider899 ) * 0.8 ) * temp_output_644_0 );
				float4 break813 = GradSpec559;
				float3 appendResult855 = (float3(break813.x , break813.y , break813.z));
				float temp_output_948_0 = ( _BaseColor.a * Hardmask981 );
				float Translucency690 = ( 1.0 - saturate( ( Gradmask982 * 1.5 ) ) );
				float4 appendResult950 = (float4(_BaseColor.r , _BaseColor.g , _BaseColor.b , saturate( ( temp_output_948_0 - Translucency690 ) )));
				float clampResult747 = clamp( ( ( 1.0 - Erodeval744 ) * 3.0 ) , 0.0 , 1.0 );
				float temp_output_862_0 = saturate( ( saturate( ( clampResult747 * _Translucency * Translucency690 ) ) * 1.0 ) );
				float clampResult773 = clamp( temp_output_862_0 , 0.0 , 0.2 );
				float4 temp_cast_2 = (clampResult773).xxxx;
				float4 temp_output_780_0 = saturate( ( ( A563 * appendResult950 ) - temp_cast_2 ) );
				float temp_output_771_0 = saturate( A563 );
				float4 temp_cast_4 = (( 1.0 - temp_output_771_0 )).xxxx;
				float4 temp_output_700_0 = ( ( ( _Lucencycol * temp_output_862_0 ) - temp_cast_4 ) * ( temp_output_771_0 * 2.0 ) );
				float4 blendOpSrc1011 = temp_output_780_0;
				float4 blendOpDest1011 = temp_output_700_0;
				float4 break716 = saturate( ( ( blendOpSrc1011 + blendOpDest1011 ) * temp_output_610_0 ) );
				float BaseColAlphaUnmasked1069 = _BaseColor.a;
				float LucencyAlpha800 = temp_output_862_0;
				float lerpResult1039 = lerp( Erosion819 , ( ( Erosion819 * temp_output_927_0 ) - saturate( ( LucencyAlpha800 * _LucencyMult ) ) ) , TranslucencySlider899);
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
Version=19105
Node;AmplifyShaderEditor.SimpleDivideOpNode;464;4781.693,3315.985;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;465;5033.833,3302.487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;5241.07,3534.751;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;794;3889.412,4407.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;792;3626.489,4074.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;733;4410.836,2941.921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;691;4539.938,2941.574;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;690;4711.478,2935.601;Inherit;True;Translucency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;470;3478.434,3330.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;596;2932.177,3233.737;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;724;3194.612,3322.728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;597;3332.347,3321.36;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;793;3593.18,3385.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;781;3909.81,1679.284;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;818;7309.372,2462.15;Inherit;True;799;BaseAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;829;7735.639,2521.666;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;830;7991.062,2591.785;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;816;8183.279,2824.553;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;857;8409.674,2836.487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;700;5471.549,2025.672;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;698;4963.422,1310.892;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;780;5421.166,2315.326;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;768;5110.188,2311.707;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;734;3706.125,1683.98;Inherit;True;3;3;0;FLOAT;1.91;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;716;7636.502,3369.349;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;744;3397.245,3063.739;Inherit;False;Erodeval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;914;4963.139,2013.565;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;2861.24,3422.815;Inherit;False;Property;_Erode;Erode;0;0;Create;True;0;0;0;False;0;False;0.98;0.726;0;0.98;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;663;3609.409,4058.484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;563;4406.322,3672.233;Inherit;True;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;859;6532.729,3360.034;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;466;4475.965,3170.874;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;467;4601.914,3460.089;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;561;6240,2800;Inherit;True;559;GradSpec;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;813;6512,2800;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;822;7520,2784;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;820;7280,2768;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;811;7008,2672;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;827;7055.603,2895.848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;821;6797.462,2857.249;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;814;6758.492,2646.264;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;979;10189.29,4676.915;Inherit;True;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;980;10409.65,4670.481;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;981;10667.69,4687.463;Inherit;False;Hardmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;940;1612.428,3992.953;Inherit;True;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;985;4230.144,3609.336;Inherit;False;981;Hardmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;697;4363.584,1304.358;Inherit;False;Property;_Lucencycol;Lucencycol;3;1;[HDR];Create;True;0;0;0;False;0;False;0.6509434,0,0.4581906,0.01960784;0.5,0,0.2104807,0.6039216;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;911;6891.977,3219.698;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;819;5673.469,3619.347;Inherit;False;Erosion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;887;8682.098,3820.87;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;670;1812.014,3772.659;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;991;2157.218,3837.35;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;668;2416.094,3844.003;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;1;[Normal];Create;True;0;0;0;False;0;False;-1;f4ae4efe9519bd6408a6e3b3dbe1194b;f7181b14bfd58474fad1df64c2e1a109;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;924;8512.061,4179.416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;992;8487.906,4308.81;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;592;4204.11,2940.747;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;771;4582.001,2005.732;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;874;4604.908,1535.573;Inherit;False;LucencyAlphaAdjust;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;800;4917.718,1683.096;Inherit;True;LucencyAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;775;5111.223,1905.128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;862;4626.938,1684.512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;567;3834,2381.982;Inherit;False;Property;_BaseColor;BaseColor;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;0.2328543,0,0.001293635,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;949;3803.055,2774.615;Inherit;False;981;Hardmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;948;4033.242,2700.723;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1010;4264.062,2606.661;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;774;5264.658,1652.337;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;693;3308.125,2524.034;Inherit;True;690;Translucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;986;6054.802,3163.965;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;855;6736.531,3063.667;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;876;7030.539,3651.085;Inherit;False;874;LucencyAlphaAdjust;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;565;4076.741,2126.973;Inherit;False;563;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;773;4808.781,2109.069;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;870;7139.181,4162.648;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;864;6891.569,4299.933;Inherit;False;800;LucencyAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;897;7653.492,4105.463;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;903;7940.767,4102.224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;900;8416.586,3902.298;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;866;7373.772,3669.29;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1019;8893.915,3703.269;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1021;9114.518,3708.068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;901;8188.145,4232.688;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1039;10787.24,3457.044;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;957;9701.873,3473.128;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;958;10086.36,3550.121;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1040;10370.24,3555.044;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;868;7805.776,3654.393;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;902;7810.862,3872.015;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;895;8112.567,3713.313;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;899;3358.527,1794.208;Inherit;False;TranslucencySlider;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;735;2985.837,1699.156;Inherit;False;Property;_Translucency;Translucency;6;0;Create;True;0;0;0;False;0;False;1;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;746;3004.794,1538.884;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;2780.746,1536.436;Inherit;True;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;547;5753.509,2424.288;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0.4528302,0.4528302,0.4528302,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;1011;5803.494,2032.551;Inherit;True;LinearDodge;False;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;772;5092.689,2020.891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;747;3298.858,1530.994;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;694;4075.904,1678.167;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;745;3163.295,1537.561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;942;2236.031,4137.457;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0.4,0.4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;962;1489.34,4365.049;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;983;1869.377,4147.532;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1047;1820.426,4492.825;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;553;4058.959,4256.159;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;740;3931.49,4234.926;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;782;3716.225,4152.918;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;831;8593.881,3083.961;Inherit;False;SpecBaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;984;4168.304,3316.322;Inherit;False;982;Gradmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;844;7808,3072;Inherit;False;ErodingSpec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;960;9629.267,3912.056;Inherit;False;Property;_LucencyMult;LucencyMult;8;0;Create;True;0;0;0;False;0;False;3;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;642;4505.377,4506.264;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;555;4202.059,4174.066;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;860;4826.92,4515.221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;556;4425.545,4043.334;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;840;5231.482,4817.293;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;845;5439.733,5105.836;Inherit;False;SpecAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;644;4927.85,4691.87;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;841;4672.7,4673.078;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;843;4429.792,4880.112;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;643;4049.476,4675.714;Inherit;False;Property;_SpecColor;SpecColor;4;1;[HDR];Create;True;0;0;0;False;0;False;27.3029,15.14408,1.858313,1;5.613354,2.029669,6.422235,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;842;3997.428,5279.535;Inherit;False;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1056;4820.485,4396.378;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1057;5390.112,4538.482;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;2,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;559;5567.437,4634.712;Inherit;False;GradSpec;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1032;10962.02,3545.938;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;560;11982.93,3258.588;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;714;12776.96,3362.763;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_maskedtrail_dev;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;5;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;834;12318.93,3353.288;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;715;11766.93,3343.288;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.32;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1066;11536.98,3615.348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1067;11367.26,3915.091;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1068;11123.63,3900.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;799;5020.012,2709.368;Inherit;False;BaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;4859.058,2328.193;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;950;4641.355,2413.493;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1009;4470.26,2609.423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1069;4135.931,2524.385;Inherit;False;BaseColAlphaUnmasked;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1065;11146.31,3768.061;Inherit;False;1069;BaseColAlphaUnmasked;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1061;5053.707,4319.586;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1063;5211.278,4398.858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1070;11572.41,3985.983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1071;11328.28,4094.613;Inherit;False;845;SpecAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;558;2875.482,4593.803;Inherit;False;Property;_Spec;Spec;1;0;Create;True;0;0;0;False;0;False;1;0.105;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;995;2530.885,4165.343;Inherit;False;Property;_NormalMult;NormalMult;9;0;Create;True;0;0;0;False;0;False;1;3.61;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;994;2995.885,4106.345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;641;3213.373,4530.902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1049;3022.677,4274.073;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1052;3359.677,4236.073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1051;3360.677,4341.073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1050;3027.677,4348.073;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1053;3066.677,4450.073;Inherit;False;Property;_SpecSharp;SpecSharp;10;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1048;3182.677,4335.073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1042;2387.587,4403.139;Inherit;False;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1045;2698.587,4416.139;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1043;2573.587,4397.139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1041;2845.332,4208.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1054;3545.268,4327.925;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;703;3399.935,4526.507;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;964;7757.576,4703.548;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;966;8100.19,4795.234;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;965;8296.435,4727.677;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;969;8824.034,4730.893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;970;8118.286,5170.424;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;971;8314.53,5102.865;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;972;8573.498,5101.256;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;973;8800.309,5098.04;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;976;9206.86,4870.835;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2.32;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;974;8997.75,4862.792;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;968;8555.402,4726.066;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;929;10249.37,4110.822;Inherit;False;wobble;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1020;10605.11,3720.667;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1027;10069.41,3899.864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1003;9803.869,3800.262;Inherit;False;800;LucencyAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1028;10254.41,3834.864;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;989;9425.486,4871.786;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;923;8493.453,4517.473;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1072;8172.836,4564.795;Inherit;False;Property;_SeqSpeedFPS;SeqSpeedFPS;11;0;Create;True;0;0;0;False;0;False;0;0;0;120;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;921;9067.027,4166.232;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;005308316ecd5544dbc59bbf4859d442;26e8463738a621d4bbc564b8061be56c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;919;8807.432,4231.551;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;5;False;2;FLOAT;5;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;982;10296.25,4354.777;Inherit;False;Gradmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;975;9805.479,4646.19;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;927;10080.78,4353.586;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1075;8863.304,4493.028;Inherit;True;Property;_SilhouetteMask;SilhouetteMask;13;0;Create;True;0;0;0;False;0;False;-1;None;7f8541b04310ea94e9ed5ff458f6d0ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;1073;9326.946,4621.287;Inherit;False;Property;_GradMaskOrTexMask;GradMaskOrTexMask;12;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;464;0;466;0
WireConnection;464;1;467;0
WireConnection;465;0;464;0
WireConnection;610;0;465;0
WireConnection;610;1;563;0
WireConnection;794;0;703;0
WireConnection;792;0;663;0
WireConnection;733;0;592;0
WireConnection;691;0;733;0
WireConnection;690;0;691;0
WireConnection;470;0;597;0
WireConnection;724;0;596;4
WireConnection;724;1;480;0
WireConnection;597;0;724;0
WireConnection;793;0;470;0
WireConnection;781;0;734;0
WireConnection;829;0;818;0
WireConnection;829;1;822;0
WireConnection;830;0;829;0
WireConnection;816;0;830;0
WireConnection;816;1;822;0
WireConnection;857;0;816;0
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
WireConnection;716;0;859;0
WireConnection;744;0;724;0
WireConnection;914;0;771;0
WireConnection;663;0;793;0
WireConnection;563;0;985;0
WireConnection;859;0;986;0
WireConnection;466;0;984;0
WireConnection;466;1;470;0
WireConnection;467;0;563;0
WireConnection;813;0;561;0
WireConnection;822;0;820;0
WireConnection;820;0;811;0
WireConnection;820;1;827;0
WireConnection;811;0;814;0
WireConnection;827;0;821;0
WireConnection;814;0;813;0
WireConnection;979;1;975;0
WireConnection;980;0;979;0
WireConnection;981;0;980;0
WireConnection;911;0;855;0
WireConnection;819;0;610;0
WireConnection;887;0;900;0
WireConnection;991;0;670;0
WireConnection;991;1;983;0
WireConnection;668;1;942;0
WireConnection;592;0;984;0
WireConnection;771;0;565;0
WireConnection;874;0;697;4
WireConnection;800;0;862;0
WireConnection;775;0;914;0
WireConnection;862;0;694;0
WireConnection;948;0;567;4
WireConnection;948;1;949;0
WireConnection;1010;0;948;0
WireConnection;1010;1;693;0
WireConnection;774;0;698;0
WireConnection;774;1;775;0
WireConnection;986;0;1011;0
WireConnection;986;1;610;0
WireConnection;855;0;813;0
WireConnection;855;1;813;1
WireConnection;855;2;813;2
WireConnection;773;0;862;0
WireConnection;870;0;864;0
WireConnection;897;0;870;0
WireConnection;903;0;897;0
WireConnection;900;0;895;0
WireConnection;900;1;901;0
WireConnection;866;1;876;0
WireConnection;1019;0;887;0
WireConnection;1021;0;1019;0
WireConnection;901;0;903;0
WireConnection;1039;0;957;0
WireConnection;1039;1;1020;0
WireConnection;1039;2;1040;0
WireConnection;958;0;957;0
WireConnection;958;1;927;0
WireConnection;868;0;866;0
WireConnection;868;1;870;0
WireConnection;895;0;868;0
WireConnection;895;1;902;0
WireConnection;899;0;735;0
WireConnection;746;0;743;0
WireConnection;547;0;780;0
WireConnection;547;1;700;0
WireConnection;1011;0;780;0
WireConnection;1011;1;700;0
WireConnection;772;0;771;0
WireConnection;747;0;745;0
WireConnection;694;0;781;0
WireConnection;745;0;746;0
WireConnection;942;0;670;0
WireConnection;942;1;983;0
WireConnection;983;0;940;0
WireConnection;983;1;1047;0
WireConnection;553;0;740;0
WireConnection;553;1;794;0
WireConnection;740;0;782;0
WireConnection;782;0;994;0
WireConnection;782;1;1052;0
WireConnection;782;2;1054;0
WireConnection;831;0;857;0
WireConnection;844;0;822;0
WireConnection;642;0;555;0
WireConnection;642;1;558;0
WireConnection;555;0;553;0
WireConnection;860;0;642;0
WireConnection;556;0;555;0
WireConnection;556;1;792;0
WireConnection;840;0;644;0
WireConnection;845;0;840;3
WireConnection;644;0;860;0
WireConnection;644;1;841;0
WireConnection;841;0;643;1
WireConnection;841;1;643;2
WireConnection;841;2;643;3
WireConnection;841;3;843;0
WireConnection;843;0;643;4
WireConnection;843;1;556;0
WireConnection;843;2;842;0
WireConnection;1057;0;1063;0
WireConnection;1057;1;644;0
WireConnection;559;0;1057;0
WireConnection;1032;0;1039;0
WireConnection;560;0;911;0
WireConnection;560;1;715;0
WireConnection;714;0;834;0
WireConnection;834;0;560;0
WireConnection;715;0;716;0
WireConnection;715;1;716;1
WireConnection;715;2;716;2
WireConnection;715;3;1066;0
WireConnection;1066;0;1070;0
WireConnection;1067;0;1065;0
WireConnection;1067;1;1068;0
WireConnection;1068;0;1032;0
WireConnection;799;0;948;0
WireConnection;564;0;565;0
WireConnection;564;1;950;0
WireConnection;950;0;567;1
WireConnection;950;1;567;2
WireConnection;950;2;567;3
WireConnection;950;3;1009;0
WireConnection;1009;0;1010;0
WireConnection;1069;0;567;4
WireConnection;1061;1;1056;0
WireConnection;1063;0;1061;0
WireConnection;1070;0;1067;0
WireConnection;1070;1;1071;0
WireConnection;994;0;668;2
WireConnection;994;1;1041;0
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
WireConnection;929;0;927;0
WireConnection;1020;0;958;0
WireConnection;1020;1;1028;0
WireConnection;1027;0;1003;0
WireConnection;1027;1;960;0
WireConnection;1028;0;1027;0
WireConnection;989;0;976;0
WireConnection;923;0;1072;0
WireConnection;921;1;919;0
WireConnection;919;0;924;0
WireConnection;919;5;923;0
WireConnection;982;0;927;0
WireConnection;975;0;921;1
WireConnection;975;1;1073;0
WireConnection;927;0;975;0
WireConnection;1073;0;989;0
WireConnection;1073;1;1075;1
ASEEND*/
//CHKSM=7FED6F35500BD20745BBC1F9F288C69364916FAC