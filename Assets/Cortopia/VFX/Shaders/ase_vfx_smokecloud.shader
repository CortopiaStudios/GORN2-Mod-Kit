// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_smokecloud"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_ErodeMap("ErodeMap", 2D) = "white" {}
		_ErodeModulator("ErodeModulator", 2D) = "white" {}
		[HDR]_Base("Base", Color) = (0.3396226,0.3396226,0.3396226,1)
		_SoftEdgeAmount("SoftEdgeAmount", Range( 0 , 1)) = 1.69274
		[HDR]_Shadow("Shadow", Color) = (0.3467041,0.4396572,1,1)
		[HDR]_Light("Light", Color) = (0.3467041,0.4396572,1,1)
		_Erode("Erode", Range( 0 , 1.1)) = 0.9961895
		[Toggle]_Erosionsource("Erosion source", Float) = 1
		[Toggle]_SoftEdge("SoftEdge", Float) = 1
		[Toggle]_InvertErodeMap("InvertErodeMap", Float) = 0
		[Toggle]_InvertErodeModulator("InvertErodeModulator", Float) = 0
		_ErodeModulation("ErodeModulation", Float) = 0.3089628
		_Clip("Clip", Range( 0 , 1)) = 0
		_AlphaMult("AlphaMult", Range( 0 , 2)) = 0
		_HighlightAmount("HighlightAmount", Range( 0 , 1)) = 0
		_HighlightSharpness("HighlightSharpness", Range( 0 , 1)) = 0
		_DistFade("DistFade", Range( 0 , 1)) = 1
		_ColConstantMin_R("ColConstantMin_R", Range( 0 , 1)) = 0.5
		_ShadeIntensity("ShadeIntensity", Range( 0 , 1)) = 0
		_ColConstantMax_R("ColConstantMax_R", Range( 0 , 1)) = 0.5
		_ShadeSharpness("ShadeSharpness", Range( 0 , 1)) = 0
		_ColConstantMin_G("ColConstantMin_G", Range( 0 , 1)) = 0.5
		_ColConstantMax_B("ColConstantMax_B", Range( 0 , 1)) = 0.5
		_ColConstantMin("ColConstantMin", Range( 0 , 1)) = 0.5
		_ColConstantMax_G("ColConstantMax_G", Range( 0 , 1)) = 0.5
		_ColConstantMin_B("ColConstantMin_B", Range( 0 , 1)) = 0.5
		_ColConstantMax("ColConstantMax", Range( 0 , 1)) = 0.5
		_Translucency("Translucency", Range( -1 , 1)) = 0
		[HDR]_HeatglowInit("HeatglowInit", Color) = (0.8301887,0,0,0)
		[HDR]_HeatglowFade("HeatglowFade", Color) = (0.8301887,0,0,0)
		_ShadeLevel("ShadeLevel", Range( -1 , 1)) = 0

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
			#include "UnityStandardBRDF.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _ShadeIntensity;
			uniform float _ShadeLevel;
			uniform float _ShadeSharpness;
			uniform float4 _Shadow;
			uniform float4 _Light;
			uniform float _Translucency;
			uniform float _HighlightAmount;
			uniform float _HighlightSharpness;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float4 _Base;
			uniform float4 _HeatglowFade;
			uniform float4 _HeatglowInit;
			uniform float _AlphaMult;
			uniform float _SoftEdge;
			uniform float _InvertErodeMap;
			uniform sampler2D _ErodeMap;
			uniform float4 _ErodeMap_ST;
			uniform float _InvertErodeModulator;
			uniform sampler2D _ErodeModulator;
			uniform float4 _ErodeModulator_ST;
			uniform float _ErodeModulation;
			uniform float _SoftEdgeAmount;
			uniform float _Erosionsource;
			uniform float _Erode;
			uniform float _DistFade;
			uniform float _Clip;
			uniform float _ColConstantMin_R;
			uniform float _ColConstantMin;
			uniform float _ColConstantMin_G;
			uniform float _ColConstantMin_B;
			uniform float _ColConstantMax_R;
			uniform float _ColConstantMax;
			uniform float _ColConstantMax_G;
			uniform float _ColConstantMax_B;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
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
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float dotResult506 = dot( float3( 0,0.39,0 ) , normalizedWorldNormal );
				float temp_output_510_0 = ( ( dotResult506 - normalizedWorldNormal.y ) - ( 1.0 - _ShadeLevel ) );
				float temp_output_512_0 = ( _ShadeIntensity * temp_output_510_0 );
				float temp_output_3_0_g8 = ( -0.05 - temp_output_512_0 );
				float lerpResult523 = lerp( temp_output_512_0 , ( 1.0 - saturate( ( temp_output_3_0_g8 / fwidth( temp_output_3_0_g8 ) ) ) ) , _ShadeSharpness);
				float temp_output_516_0 = saturate( lerpResult523 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = Unity_SafeNormalize( ase_worldViewDir );
				float dotResult324 = dot( ase_worldViewDir , normalizedWorldNormal );
				float temp_output_356_0 = ( dotResult324 - normalizedWorldNormal.y );
				float temp_output_325_0 = ( ( 1.0 - ( temp_output_356_0 - _Translucency ) ) * _HighlightAmount );
				float temp_output_3_0_g7 = ( 1.0 - temp_output_325_0 );
				float temp_output_446_0 = ( 1.0 - saturate( ( temp_output_3_0_g7 / fwidth( temp_output_3_0_g7 ) ) ) );
				float lerpResult448 = lerp( temp_output_325_0 , temp_output_446_0 , _HighlightSharpness);
				float2 texCoord121 = i.ase_texcoord2.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 temp_output_310_0 = ( tex2D( _TextureSample0, texCoord121 ) * 2.0 );
				float4 temp_output_425_0 = ( 1.0 - temp_output_310_0 );
				float4 blendOpSrc335 = saturate( ( _Light * lerpResult448 ) );
				float4 blendOpDest335 = saturate( ( ( temp_output_310_0 * _Base ) + ( ( temp_output_425_0 * _Base ) / 2.0 ) ) );
				float4 lerpBlendMode335 = lerp(blendOpDest335,( blendOpSrc335 + blendOpDest335 ),i.ase_color.a);
				float Shadow522 = ( temp_output_516_0 * 0.4 );
				float4 temp_cast_0 = (saturate( Shadow522 )).xxxx;
				float4 temp_output_529_0 = saturate( ( ( temp_output_516_0 * _Shadow ) + saturate( ( saturate( lerpBlendMode335 ) - temp_cast_0 ) ) ) );
				float Hilite475 = temp_output_446_0;
				float4 temp_cast_1 = (Hilite475).xxxx;
				float4 temp_output_479_0 = saturate( ( saturate( ( ( _HeatglowFade * i.ase_color.b ) + ( _HeatglowInit * i.ase_color.r ) ) ) - temp_cast_1 ) );
				float4 break200 = ( temp_output_529_0 + temp_output_479_0 );
				float2 panner345 = ( 0.2 * _Time.y * float2( -0.1,-0.2 ) + float2( 0,0 ));
				float2 texCoord222 = i.ase_texcoord2.xy * _ErodeMap_ST.xy + ( _ErodeMap_ST.zw + panner345 );
				float2 panner339 = ( 0.4 * _Time.y * float2( -0.2,-0.1 ) + float2( 0,0 ));
				float2 texCoord338 = i.ase_texcoord2.xy * _ErodeModulator_ST.xy + ( _ErodeModulator_ST.zw + panner339 );
				float4 tex2DNode336 = tex2D( _ErodeModulator, texCoord338 );
				float2 temp_cast_2 = ((( _InvertErodeModulator )?( ( 1.0 - tex2DNode336.r ) ):( tex2DNode336.r ))).xx;
				float2 lerpResult352 = lerp( texCoord222 , temp_cast_2 , _ErodeModulation);
				float4 tex2DNode221 = tex2D( _ErodeMap, lerpResult352 );
				float3 normalizeResult300 = normalize( normalizedWorldNormal );
				float3 normalizeResult299 = normalize( ase_worldViewDir );
				float dotResult302 = dot( normalizeResult300 , normalizeResult299 );
				float temp_output_303_0 = ( _SoftEdgeAmount * dotResult302 );
				float SoftEdgeFres393 = temp_output_303_0;
				float temp_output_396_0 = ( 1.0 - SoftEdgeFres393 );
				float temp_output_364_0 = ( break200.a * ( (( _InvertErodeMap )?( ( 1.0 - tex2DNode221.r ) ):( tex2DNode221.r )) * ( ( temp_output_396_0 * ( temp_output_396_0 + 1.0 ) ) * 3.0 ) ) );
				float temp_output_3_0_g6 = ( (( _Erosionsource )?( (0.0 + (i.ase_color.a - 0.0) * (1.01 - 0.0) / (1.0 - 0.0)) ):( _Erode )) - temp_output_364_0 );
				float lerpResult217 = lerp( temp_output_364_0 , saturate( ( temp_output_3_0_g6 / fwidth( temp_output_3_0_g6 ) ) ) , (0.0 + ((( _Erosionsource )?( (0.0 + (i.ase_color.a - 0.0) * (1.01 - 0.0) / (1.0 - 0.0)) ):( _Erode )) - -1.0) * (1.0 - 0.0) / (0.0 - -1.0)));
				float temp_output_432_0 = saturate( lerpResult217 );
				float saferPower388 = abs( ( distance( _WorldSpaceCameraPos , WorldPosition ) / ( _DistFade * 300.0 ) ) );
				float clampResult391 = clamp( pow( saferPower388 , 0.7 ) , 0.0 , 1.0 );
				float clampResult387 = clamp( ( ( temp_output_432_0 * saturate( ( temp_output_303_0 + ( ( temp_output_303_0 * 4.04 ) - ( 1.0 - temp_output_303_0 ) ) ) ) ) * ( 1.0 - clampResult391 ) ) , 0.0 , 0.9 );
				float temp_output_441_0 = saturate( ( ( _AlphaMult * ( i.ase_color.a * 10.0 ) ) * (( _SoftEdge )?( clampResult387 ):( temp_output_432_0 )) ) );
				float4 appendResult202 = (float4(break200.r , break200.g , break200.b , temp_output_441_0));
				clip( temp_output_441_0 - _Clip);
				float4 appendResult423 = (float4(( _ColConstantMin_R * _ColConstantMin ) , ( _ColConstantMin_G * _ColConstantMin ) , ( _ColConstantMin_B * _ColConstantMin ) , 0.0));
				float4 appendResult471 = (float4(( _ColConstantMax_R * _ColConstantMax ) , ( _ColConstantMax_G * _ColConstantMax ) , ( _ColConstantMax_B * _ColConstantMax ) , 1.0));
				float4 clampResult421 = clamp( saturate( appendResult202 ) , appendResult423 , appendResult471 );
				
				
				finalColor = saturate( clampResult421 );
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
Node;AmplifyShaderEditor.TextureTransformNode;337;306.4421,1986.529;Inherit;False;336;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.WorldNormalVector;297;2857.315,3024.674;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;339;341.1747,2430.723;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.2,-0.1;False;1;FLOAT;0.4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;298;2880.789,3295.811;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;300;3153.005,3133.395;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;299;3151.005,3209.395;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;340;568.2315,2300.309;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;302;3323.211,3157.395;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;338;724.3748,2146.807;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;301;3245.443,2896.592;Inherit;False;Property;_SoftEdgeAmount;SoftEdgeAmount;4;0;Create;True;0;0;0;False;0;False;1.69274;0.407;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;223;886.3579,1596.155;Inherit;False;221;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;336;957.3975,2113.356;Inherit;True;Property;_ErodeModulator;ErodeModulator;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;345;888.1462,1735.322;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,-0.2;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;393;3856.927,2669.716;Inherit;False;SoftEdgeFres;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;402;1250.012,2376.258;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;346;1206.044,1933.984;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;222;1371.842,1847.655;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;403;1450.661,2147.011;Inherit;False;Property;_InvertErodeModulator;InvertErodeModulator;11;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;1422.433,2546.355;Inherit;False;Property;_ErodeModulation;ErodeModulation;12;0;Create;True;0;0;0;False;0;False;0.3089628;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;352;1795.134,2035.01;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;396;2467.177,2229.934;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;221;1957.738,2006.49;Inherit;True;Property;_ErodeMap;ErodeMap;1;0;Create;True;0;0;0;False;0;False;-1;None;7cf6afe4105669349bd222f33ba5795d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;240;2406.224,2052.472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;399;2848.177,2235.934;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;333;2578.877,1885.802;Inherit;False;Property;_InvertErodeMap;InvertErodeMap;10;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;3068.379,2304.388;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;212;2581.98,2783.348;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;377;3832.215,3666.395;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;3134.177,2037.934;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;2727.662,2536.284;Inherit;False;Property;_Erode;Erode;7;0;Create;True;0;0;0;False;0;False;0.9961895;1.097;0;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;244;2857.446,2725.507;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;413;3793.612,3878.766;Inherit;False;Property;_DistFade;DistFade;17;0;Create;True;0;0;0;False;0;False;1;0.575;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;376;3789.892,3466.714;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;410;3877.323,3259.091;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;389;4071.279,3634.309;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;415;4115.084,3897.659;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;409;3850.77,3036.519;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;213;3166.969,2626.413;Inherit;False;Property;_Erosionsource;Erosion source;8;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;214;3423.467,2642.833;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;380;4294.164,3626.68;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;411;4123.489,3114.373;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;407;4423.633,2816.458;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;388;4516.937,3569.821;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;408;4645.096,2797.154;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;391;4739.53,3392.686;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;390;4908.13,3277.524;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;329;4803.673,2658.73;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;386;5030.304,2866.434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;401;4998.392,2248.236;Inherit;False;Property;_AlphaMult;AlphaMult;14;0;Create;True;0;0;0;False;0;False;0;0.14;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;387;5197.022,2724.047;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;440;5151.126,2430.805;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;438;5366.126,2273.805;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;321;5355.102,2551.752;Inherit;True;Property;_SoftEdge;SoftEdge;9;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;5610.392,2441.236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;441;5777.126,2564.805;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;461;6633.909,2828.452;Inherit;False;Property;_ColConstantMin_R;ColConstantMin_R;18;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;419;6640.731,3186.563;Inherit;False;Property;_ColConstantMin;ColConstantMin;24;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;460;6639.909,2941.452;Inherit;False;Property;_ColConstantMin_G;ColConstantMin_G;22;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;433;6630.203,3633.045;Inherit;False;Property;_ColConstantMax;ColConstantMax;27;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;465;6618.685,3393.949;Inherit;False;Property;_ColConstantMax_R;ColConstantMax_R;20;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;5866.876,2769.651;Inherit;False;Property;_Clip;Clip;13;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;466;6619.685,3466.949;Inherit;False;Property;_ColConstantMax_G;ColConstantMax_G;25;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;467;6624.685,3547.949;Inherit;False;Property;_ColConstantMax_B;ColConstantMax_B;23;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;459;6640.909,3034.452;Inherit;False;Property;_ColConstantMin_B;ColConstantMin_B;26;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;464;7018.909,3113.452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;7001.909,2833.452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;463;7011.909,2967.452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;468;6998.685,3650.949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;6991.685,3504.949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;323;6285.642,2606.05;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;469;6981.685,3370.949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;471;7165.258,3482.465;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;199;6706.645,2572.487;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;232;2740.838,2074.697;Inherit;False;ErodeMap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;439;4889.497,2336.818;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;423;7162.482,2804.968;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;421;7413.204,2620.396;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.2,0.2,0.2,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;488;7555.763,2543.379;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;458;8444.016,2632.448;Float;False;True;-1;2;ASEMaterialInspector;100;5;Cortopia/VFX/ase_vfx_smokecloud;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;364;3455.896,1730.078;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;202;5900.805,2262.549;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;395;2169.177,2251.934;Inherit;True;393;SoftEdgeFres;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;3566.889,2974.031;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;398;2691.177,2423.934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;200;4059.547,1530.291;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;432;4217.357,2387.112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;217;3947.957,2203.596;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;215;3639.087,2215.265;Inherit;True;Step Antialiasing;-1;;6;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;497;1663.273,-1125.71;Inherit;False;232;ErodeMap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;484;3310.634,-1055.069;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;487;3018.133,-1335.87;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;480;2797.503,-1461.967;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;15;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;474;2817.125,-1270.386;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;473;2321.271,-1065.953;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;472;1776.568,-1416.11;Inherit;False;Property;_HeatglowInit;HeatglowInit;29;1;[HDR];Create;True;0;0;0;False;0;False;0.8301887,0,0,0;0.490566,0.1215279,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;500;2021.672,-1290.08;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;499;2133.672,-1136.079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;502;2323.672,-1279.08;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;501;1854.672,-983.0786;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldNormalVector;326;-1221.516,-843.6603;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;356;-678.3105,-762.3002;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;456;-557.3625,-583.5956;Inherit;False;Property;_Translucency;Translucency;28;0;Create;True;0;0;0;False;0;False;0;0.685;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;203;-2265.279,-183.6941;Inherit;False;120;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;121;-1871.084,-155.0441;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;455;-436.6707,-694.7275;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.61;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;405;-367.5557,-195.784;Inherit;False;Property;_HighlightAmount;HighlightAmount;15;0;Create;True;0;0;0;False;0;False;0;0.987;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;359;-300.7085,-613.6243;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;120;-1208.73,-271.0437;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;07fa516b0750c334e9fabd819eb77002;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;-36.21455,-322.9106;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;444;33.34256,40.71862;Inherit;True;Step Antialiasing;-1;;7;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;118;-490.5596,585.2756;Inherit;False;Property;_Base;Base;3;1;[HDR];Create;True;0;0;0;False;0;False;0.3396226,0.3396226,0.3396226,1;0.04405482,0.06082234,0.1698113,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;428;44.67853,603.962;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;446;269.5513,72.86549;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;445;-346.8286,-57.11987;Inherit;False;Property;_HighlightSharpness;HighlightSharpness;16;0;Create;True;0;0;0;False;0;False;0;0.402;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;431;4.104546,905.2889;Inherit;False;Constant;_Float3;Float 3;17;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;430;272.7944,875.0579;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;448;410.7206,-111.6295;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-201.5666,439.9785;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;176;85.59845,-555.0462;Inherit;False;Property;_Light;Light;6;1;[HDR];Create;True;0;0;0;False;0;False;0.3467041,0.4396572,1,1;0.3300107,0.6134209,0.6792453,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;429;468.6786,518.962;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;625.4127,-154.0565;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;442;699.3307,401.2436;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;374;678.8737,898.4449;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;443;862.3094,59.45383;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;457;1233.109,712.5892;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;314;-1367.41,-392.97;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;1,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;315;-2247.411,-440.9699;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;316;-2265.663,-749.3552;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;317;-2024.004,-698.6293;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;-1833.891,-492.23;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;475;634.5118,127.2653;Inherit;False;Hilite;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;335;957.0914,465.7831;Inherit;True;LinearDodge;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;-651.0566,-66.13107;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;425;-244.9695,122.8985;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;498;139.1844,343.2007;Inherit;False;Maintex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-523.3396,-1029.478;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;327;-1002.298,-1054.425;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;324;-796.577,-849.0851;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;505;-2187.539,-2506.693;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;506;-1811.507,-2532.958;Inherit;False;2;0;FLOAT3;0,0.39,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;508;-1644.334,-2425.333;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;510;-1458.694,-2359.76;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.61;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;511;-1231.596,-2122.601;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-1279.078,-2539.576;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;516;-360.5225,-2137.869;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;518;-539.9222,-1934.805;Inherit;False;Property;_Shadow;Shadow;5;1;[HDR];Create;True;0;0;0;False;0;False;0.3467041,0.4396572,1,1;0.2118192,0.2613556,0.5283019,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;519;-198.5644,-2021.106;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;521;-1454.274,-2877.084;Inherit;False;Property;_ShadeSharpness;ShadeSharpness;21;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;522;62.40572,-2310.367;Inherit;False;Shadow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;523;-663.7973,-2813.851;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;524;1776.065,-702.9197;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;526;1117.553,-408.51;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;527;1341.635,-643.2796;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;528;1581.232,-542.9347;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;525;852.3108,-345.1689;Inherit;False;522;Shadow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;517;-181.6114,-2148.084;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;477;2650.098,-644.2841;Inherit;True;475;Hilite;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;476;3408.021,-769.706;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;529;2358.216,-385.449;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;414;3857.415,4068.404;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;300;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;454;-1165.873,-448.4722;Inherit;False;Constant;_Float1;Float 1;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-877.2694,111.1164;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;509;-1584.38,-2582.689;Inherit;False;Property;_ShadeIntensity;ShadeIntensity;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;514;-983.2308,-2531.021;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;520;-1018.813,-2255.418;Inherit;True;Step Antialiasing;-1;;8;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;-0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;530;-684.0865,-2336.074;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;531;-1586.781,-2112.496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;507;-1927.346,-2105.207;Inherit;False;Property;_ShadeLevel;ShadeLevel;31;0;Create;True;0;0;0;False;0;False;0;0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;504;4270.651,203.902;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;491;3059.118,-1023.231;Inherit;False;HeatGlow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;485;2358.218,-1613.855;Inherit;False;Property;_HeatglowFade;HeatglowFade;30;1;[HDR];Create;True;0;0;0;False;0;False;0.8301887,0,0,0;0.2264151,0.007476025,0.007475975,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;486;2616.788,-1047.036;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;490;2852.154,-839.6906;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;532;3822.702,-612.3608;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;479;3621.52,-513.2271;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;503;3771.659,109.7792;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;300;0;297;0
WireConnection;299;0;298;0
WireConnection;340;0;337;1
WireConnection;340;1;339;0
WireConnection;302;0;300;0
WireConnection;302;1;299;0
WireConnection;338;0;337;0
WireConnection;338;1;340;0
WireConnection;336;1;338;0
WireConnection;393;0;303;0
WireConnection;402;0;336;1
WireConnection;346;0;223;1
WireConnection;346;1;345;0
WireConnection;222;0;223;0
WireConnection;222;1;346;0
WireConnection;403;0;336;1
WireConnection;403;1;402;0
WireConnection;352;0;222;0
WireConnection;352;1;403;0
WireConnection;352;2;343;0
WireConnection;396;0;395;0
WireConnection;221;1;352;0
WireConnection;240;0;221;1
WireConnection;399;0;396;0
WireConnection;399;1;398;0
WireConnection;333;0;221;1
WireConnection;333;1;240;0
WireConnection;406;0;399;0
WireConnection;394;0;333;0
WireConnection;394;1;406;0
WireConnection;244;0;212;4
WireConnection;410;0;303;0
WireConnection;389;0;376;0
WireConnection;389;1;377;0
WireConnection;415;0;413;0
WireConnection;415;1;414;0
WireConnection;409;0;303;0
WireConnection;213;0;211;0
WireConnection;213;1;244;0
WireConnection;214;0;213;0
WireConnection;380;0;389;0
WireConnection;380;1;415;0
WireConnection;411;0;409;0
WireConnection;411;1;410;0
WireConnection;407;0;303;0
WireConnection;407;1;411;0
WireConnection;388;0;380;0
WireConnection;408;0;407;0
WireConnection;391;0;388;0
WireConnection;390;0;391;0
WireConnection;329;0;432;0
WireConnection;329;1;408;0
WireConnection;386;0;329;0
WireConnection;386;1;390;0
WireConnection;387;0;386;0
WireConnection;440;0;439;4
WireConnection;438;0;401;0
WireConnection;438;1;440;0
WireConnection;321;0;432;0
WireConnection;321;1;387;0
WireConnection;400;0;438;0
WireConnection;400;1;321;0
WireConnection;441;0;400;0
WireConnection;464;0;459;0
WireConnection;464;1;419;0
WireConnection;462;0;461;0
WireConnection;462;1;419;0
WireConnection;463;0;460;0
WireConnection;463;1;419;0
WireConnection;468;0;467;0
WireConnection;468;1;433;0
WireConnection;470;0;466;0
WireConnection;470;1;433;0
WireConnection;323;0;202;0
WireConnection;323;1;441;0
WireConnection;323;2;392;0
WireConnection;469;0;465;0
WireConnection;469;1;433;0
WireConnection;471;0;469;0
WireConnection;471;1;470;0
WireConnection;471;2;468;0
WireConnection;199;0;323;0
WireConnection;232;0;333;0
WireConnection;423;0;462;0
WireConnection;423;1;463;0
WireConnection;423;2;464;0
WireConnection;421;0;199;0
WireConnection;421;1;423;0
WireConnection;421;2;471;0
WireConnection;488;0;421;0
WireConnection;458;0;488;0
WireConnection;364;0;200;3
WireConnection;364;1;394;0
WireConnection;202;0;200;0
WireConnection;202;1;200;1
WireConnection;202;2;200;2
WireConnection;202;3;441;0
WireConnection;303;0;301;0
WireConnection;303;1;302;0
WireConnection;398;0;396;0
WireConnection;200;0;504;0
WireConnection;432;0;217;0
WireConnection;217;0;364;0
WireConnection;217;1;215;0
WireConnection;217;2;214;0
WireConnection;215;1;364;0
WireConnection;215;2;213;0
WireConnection;484;0;487;0
WireConnection;487;0;480;0
WireConnection;487;1;474;0
WireConnection;480;0;485;0
WireConnection;480;1;473;3
WireConnection;474;0;472;0
WireConnection;474;1;473;1
WireConnection;500;0;472;0
WireConnection;499;0;500;3
WireConnection;499;1;501;0
WireConnection;502;0;500;0
WireConnection;502;1;500;1
WireConnection;502;2;500;2
WireConnection;502;3;499;0
WireConnection;501;0;497;0
WireConnection;356;0;324;0
WireConnection;356;1;326;2
WireConnection;121;0;203;0
WireConnection;121;1;203;1
WireConnection;455;0;356;0
WireConnection;455;1;456;0
WireConnection;359;0;455;0
WireConnection;120;1;121;0
WireConnection;325;0;359;0
WireConnection;325;1;405;0
WireConnection;444;1;325;0
WireConnection;428;0;425;0
WireConnection;428;1;118;0
WireConnection;446;0;444;0
WireConnection;430;0;428;0
WireConnection;430;1;431;0
WireConnection;448;0;325;0
WireConnection;448;1;446;0
WireConnection;448;2;445;0
WireConnection;119;0;310;0
WireConnection;119;1;118;0
WireConnection;429;0;119;0
WireConnection;429;1;430;0
WireConnection;328;0;176;0
WireConnection;328;1;448;0
WireConnection;442;0;429;0
WireConnection;443;0;328;0
WireConnection;457;0;335;0
WireConnection;314;0;318;0
WireConnection;314;1;121;0
WireConnection;317;0;316;0
WireConnection;317;1;315;0
WireConnection;318;0;317;0
WireConnection;318;1;315;0
WireConnection;475;0;446;0
WireConnection;335;0;443;0
WireConnection;335;1;442;0
WireConnection;335;2;374;4
WireConnection;310;0;120;0
WireConnection;310;1;306;0
WireConnection;425;0;310;0
WireConnection;498;0;425;0
WireConnection;435;0;356;0
WireConnection;324;0;327;0
WireConnection;324;1;326;0
WireConnection;506;1;505;0
WireConnection;508;0;506;0
WireConnection;508;1;505;2
WireConnection;510;0;508;0
WireConnection;510;1;531;0
WireConnection;511;0;510;0
WireConnection;512;0;509;0
WireConnection;512;1;510;0
WireConnection;516;0;523;0
WireConnection;519;0;516;0
WireConnection;519;1;518;0
WireConnection;522;0;517;0
WireConnection;523;0;512;0
WireConnection;523;1;530;0
WireConnection;523;2;521;0
WireConnection;524;0;519;0
WireConnection;524;1;528;0
WireConnection;526;0;525;0
WireConnection;527;0;457;0
WireConnection;527;1;526;0
WireConnection;528;0;527;0
WireConnection;517;0;516;0
WireConnection;476;0;484;0
WireConnection;476;1;477;0
WireConnection;529;0;524;0
WireConnection;514;0;512;0
WireConnection;514;1;521;0
WireConnection;520;1;512;0
WireConnection;530;0;520;0
WireConnection;531;0;507;0
WireConnection;504;0;529;0
WireConnection;504;1;479;0
WireConnection;491;0;490;0
WireConnection;486;0;473;1
WireConnection;486;1;473;3
WireConnection;490;0;486;0
WireConnection;490;1;473;3
WireConnection;532;0;479;0
WireConnection;479;0;476;0
WireConnection;503;0;529;0
ASEEND*/
//CHKSM=BB9B6B32252BDBEB68F08049E9D72564402479D8