// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_diffusestains_fakelight"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_StainNoise("StainNoise", 2D) = "white" {}
		_Radius("Radius", Float) = 0.4
		[HDR]_Colorize("Colorize", Color) = (0.8396226,0.6693218,0.6693218,0)
		[HDR]_DetailColor("DetailColor", Color) = (0.5660378,0,0.009433819,1)
		[HDR]_ColorLight("ColorLight", Color) = (0.830163,0,1,1)
		_Hardness("Hardness", Float) = 0.3
		_Nul("Nul", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		_Highlight("Highlight", Range( 0 , 1.2)) = 1
		_StainIntensity("StainIntensity", Range( 0 , 1)) = 1
		_LightedIntensity("LightedIntensity", Range( 0 , 1)) = 0
		[Toggle(_STAIN_R_ON)] _Stain_R("Stain_R", Float) = 1
		[Toggle(_STAIN_G_ON)] _Stain_G("Stain_G", Float) = 1
		[Toggle(_STAIN_B_ON)] _Stain_B("Stain_B", Float) = 0
		[Toggle]_InvertStainMask("InvertStainMask", Float) = 1

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
			#pragma shader_feature_local _STAIN_R_ON
			#pragma shader_feature_local _STAIN_G_ON
			#pragma shader_feature_local _STAIN_B_ON


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
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Normal;
			uniform float _Highlight;
			uniform float4 _ColorLight;
			uniform float _InvertStainMask;
			uniform float _Hardness;
			uniform float _Radius;
			uniform float _Nul;
			uniform sampler2D _StainNoise;
			uniform float4 _StainNoise_ST;
			uniform float4 _DetailColor;
			uniform sampler2D _MainTexture;
			uniform float4 _ST;
			uniform float4 _Colorize;
			uniform float _StainIntensity;
			uniform float _LightedIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
				float2 texCoord230 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float3 tex2DNode229 = UnpackNormal( tex2D( _Normal, texCoord230 ) );
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float smoothstepResult234 = smoothstep( 0.25 , 0.53 , ( ( tex2DNode229.g * 0.5 ) + (normalizedWorldNormal.y*_Highlight + -0.28) ));
				float2 uv_StainNoise = i.ase_texcoord1.xy * _StainNoise_ST.xy + _StainNoise_ST.zw;
				float4 tex2DNode373 = tex2D( _StainNoise, uv_StainNoise );
				#ifdef _STAIN_R_ON
				float staticSwitch378 = tex2DNode373.r;
				#else
				float staticSwitch378 = _Nul;
				#endif
				#ifdef _STAIN_G_ON
				float staticSwitch380 = tex2DNode373.g;
				#else
				float staticSwitch380 = _Nul;
				#endif
				#ifdef _STAIN_B_ON
				float staticSwitch381 = tex2DNode373.b;
				#else
				float staticSwitch381 = _Nul;
				#endif
				float smoothstepResult212 = smoothstep( ( _Hardness * _Radius ) , _Radius , ( staticSwitch378 + staticSwitch380 + staticSwitch381 ));
				float temp_output_246_0 = saturate( smoothstepResult212 );
				float4 temp_output_207_0 = ( (( _InvertStainMask )?( ( 1.0 - temp_output_246_0 ) ):( temp_output_246_0 )) * _DetailColor );
				float4 temp_output_210_0 = saturate( temp_output_207_0 );
				float2 texCoord368 = i.ase_texcoord1.xy * _ST.xy + _ST.zw;
				float4 temp_cast_0 = (saturate( ( (( _InvertStainMask )?( ( 1.0 - temp_output_246_0 ) ):( temp_output_246_0 )) * ( _StainIntensity * 0.5 ) ) )).xxxx;
				float4 temp_output_399_0 = saturate( ( saturate( ( tex2D( _MainTexture, texCoord368 ) * _Colorize ) ) - temp_cast_0 ) );
				float4 blendOpSrc401 = temp_output_210_0;
				float4 blendOpDest401 = temp_output_399_0;
				float4 lerpBlendMode401 = lerp(blendOpDest401,( 1.0 - ( 1.0 - blendOpSrc401 ) * ( 1.0 - blendOpDest401 ) ),_StainIntensity);
				float4 temp_output_211_0 = saturate( ( saturate( lerpBlendMode401 )) );
				float clampResult340 = clamp( _LightedIntensity , 0.12 , 1.0 );
				
				
				finalColor = saturate( ( ( saturate( ( smoothstepResult234 + ( tex2DNode229.b * 0.01 * ( 1.0 - texCoord230.y ) ) ) ) * _ColorLight ) + ( temp_output_211_0 * clampResult340 ) ) );
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;313.4197,-126.0126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;762.1938,-640.2702;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;229;1071.593,-636.3697;Inherit;True;Property;_Normal;Normal;8;0;Create;True;0;0;0;False;0;False;-1;None;f83c6c3fa08d4b1488c3af1e78faf2a8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;233;1737.194,-332.1703;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;1486.295,-562.2701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;220;632.1954,-399.3703;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;225;874.3931,-309.9704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;1052.943,-139.2488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;1918.194,66.92929;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;1943.894,-173.5705;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;226;1134.292,-317.4704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;737.8118,-137.7947;Inherit;False;Property;_Highlight;Highlight;9;0;Create;True;0;0;0;False;0;False;1;1.137;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;227;2138.851,62.91878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;244;2993.522,727.9783;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2757.433,689.9656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-841.2159,216.237;Inherit;False;Property;_Colorize;Colorize;3;1;[HDR];Create;True;0;0;0;False;0;False;0.8396226,0.6693218,0.6693218,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2490.416,713.0248;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;221;1798.968,340.5208;Inherit;False;Property;_ColorLight;ColorLight;5;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.5097454,0.5522014,0.7452831,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;360;1782.183,1005.571;Inherit;False;Property;_HeightLight_Effect;HeightLight_Effect;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;340;2352.459,839.0605;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;2193.382,1090.583;Inherit;False;Property;_LightedIntensity;LightedIntensity;11;0;Create;True;0;0;0;False;0;False;0;0.676;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;366;1737.585,717.8712;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;367;1846.785,690.5713;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;1886.185,780.6717;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;364;2137.085,667.5718;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;350;1791.705,665.1592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;357;1498.138,808.3052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;368;-1301.869,-198.1348;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;370;-1580.952,-140.045;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;384;-504.8445,1173.849;Inherit;False;Property;_Radius;Radius;2;0;Create;True;0;0;0;False;0;False;0.4;0.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;371;-1184.489,536.457;Inherit;False;0;373;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;372;-1458.884,594.5468;Inherit;False;373;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;-370.9168,898.0627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-880.8401,946.7371;Inherit;False;Property;_Nul;Nul;7;0;Create;True;0;0;0;False;0;False;0;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;373;-969.1318,487.4363;Inherit;True;Property;_StainNoise;StainNoise;1;0;Create;True;0;0;0;False;0;False;-1;07fa516b0750c334e9fabd819eb77002;07fa516b0750c334e9fabd819eb77002;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;378;-599.6395,428.2624;Inherit;True;Property;_Stain_R;Stain_R;15;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;380;-603.0147,659.5829;Inherit;False;Property;_Stain_G;Stain_G;16;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;381;-591.026,762.9172;Inherit;True;Property;_Stain_B;Stain_B;17;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-971.9001,-233.0901;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;bfd675cc0db1d4656b75dc6d6ba91142;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;353;1081.5,1069.243;Inherit;False;Property;_HeightLight_MaxHeight;HeightLight_MaxHeight;12;0;Create;True;0;0;0;False;0;False;0.5;1.71;0.5;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;1001.445,894.4971;Inherit;False;Property;_HeightLight_MinValue;HeightLight_MinValue;14;0;Create;True;0;0;0;False;0;False;1;0.568;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;352;1142.417,750.1525;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;211;1579.056,354.6398;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;383;-599.6992,1089.826;Inherit;False;Property;_Hardness;Hardness;6;0;Create;True;0;0;0;False;0;False;0.3;0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;-178.8036,517.4263;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;101;564.9113,-25.09914;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;210;1058.671,470.6352;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;542.7966,323.826;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;-115.1171,821.7826;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;391;798.7964,536.6262;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;246;85.73999,400.659;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;206;320.7365,728.2806;Inherit;False;Property;_DetailColor;DetailColor;4;1;[HDR];Create;True;0;0;0;False;0;False;0.5660378,0,0.009433819,1;0.4716981,0.4027234,0.4040248,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;398;152.3974,669.4267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;771.3459,857.2706;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;608.3618,623.8471;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;209;315.9546,968.3732;Inherit;False;Property;_StainIntensity;StainIntensity;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;397;295.7975,426.6262;Inherit;False;Property;_InvertStainMask;InvertStainMask;18;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;399;1235.362,187.8471;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;389;965.6597,181.2368;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;396;757.7968,220.626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;402;458.3618,570.8471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2291.479,318.5984;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;1455.095,-64.37054;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;1338.006,287.4185;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;401;1398.362,534.8471;Inherit;True;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;3506.715,744.7441;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_diffusestains_fakelight;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;229;1;230;0
WireConnection;233;0;235;0
WireConnection;233;1;226;0
WireConnection;235;0;229;2
WireConnection;225;0;220;2
WireConnection;243;0;230;2
WireConnection;242;0;234;0
WireConnection;242;1;240;0
WireConnection;234;0;233;0
WireConnection;226;0;220;2
WireConnection;226;1;258;0
WireConnection;227;0;242;0
WireConnection;244;0;223;0
WireConnection;223;0;222;0
WireConnection;223;1;337;0
WireConnection;337;0;211;0
WireConnection;337;1;340;0
WireConnection;340;0;338;0
WireConnection;366;0;211;0
WireConnection;367;0;350;0
WireConnection;365;0;366;0
WireConnection;365;1;357;0
WireConnection;364;0;367;0
WireConnection;364;1;365;0
WireConnection;364;2;360;0
WireConnection;350;0;211;0
WireConnection;357;0;352;2
WireConnection;357;1;358;0
WireConnection;357;2;353;0
WireConnection;368;0;370;0
WireConnection;368;1;370;1
WireConnection;371;0;372;0
WireConnection;371;1;372;1
WireConnection;385;0;383;0
WireConnection;385;1;384;0
WireConnection;373;1;371;0
WireConnection;378;1;387;0
WireConnection;378;0;373;1
WireConnection;380;1;387;0
WireConnection;380;0;373;2
WireConnection;381;1;387;0
WireConnection;381;0;373;3
WireConnection;5;1;368;0
WireConnection;211;0;401;0
WireConnection;390;0;378;0
WireConnection;390;1;380;0
WireConnection;390;2;381;0
WireConnection;101;0;24;0
WireConnection;210;0;207;0
WireConnection;392;0;397;0
WireConnection;392;1;402;0
WireConnection;212;0;390;0
WireConnection;212;1;385;0
WireConnection;212;2;384;0
WireConnection;391;0;400;0
WireConnection;391;1;207;0
WireConnection;391;2;209;0
WireConnection;246;0;212;0
WireConnection;398;0;246;0
WireConnection;207;0;397;0
WireConnection;207;1;206;0
WireConnection;400;0;206;0
WireConnection;400;1;209;0
WireConnection;397;0;246;0
WireConnection;397;1;398;0
WireConnection;399;0;389;0
WireConnection;389;0;101;0
WireConnection;389;1;396;0
WireConnection;396;0;392;0
WireConnection;402;0;209;0
WireConnection;222;0;227;0
WireConnection;222;1;221;0
WireConnection;240;0;229;3
WireConnection;240;2;243;0
WireConnection;205;0;399;0
WireConnection;205;1;210;0
WireConnection;401;0;210;0
WireConnection;401;1;399;0
WireConnection;401;2;209;0
WireConnection;257;0;244;0
ASEEND*/
//CHKSM=CBCC2E8E812FB2A1FB88772169513E67BC1AB7B3