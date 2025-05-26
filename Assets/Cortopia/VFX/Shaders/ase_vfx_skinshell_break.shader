// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_skinshell_break"
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
		_Normal("Normal", 2D) = "bump" {}
		_Highlight("Highlight", Range( 0 , 1.2)) = 1
		_StainIntensity("StainIntensity", Range( 0 , 1)) = 1
		_LightedIntensity("LightedIntensity", Range( 0 , 1)) = 0
		[Toggle(_STAIN_R_ON)] _Stain_R("Stain_R", Float) = 1
		[Toggle(_DEFORM_R_ON)] _Deform_R("Deform_R", Float) = 1
		[Toggle(_STAIN_G_ON)] _Stain_G("Stain_G", Float) = 1
		[Toggle(_DEFORM_G_ON)] _Deform_G("Deform_G", Float) = 1
		[Toggle(_STAIN_B_ON)] _Stain_B("Stain_B", Float) = 0
		[Toggle(_DEFORM_B_ON)] _Deform_B("Deform_B", Float) = 0
		[Toggle]_InvertStainMask("InvertStainMask", Float) = 1
		_Deformer("Deformer", 2D) = "white" {}
		[Toggle]_DeformVCol_or_Manual("DeformVCol_or_Manual", Float) = 1
		_Deform("Deform", Float) = 0
		_DeformMult("DeformMult", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
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
			#define ASE_NEEDS_VERT_COLOR
			#pragma shader_feature_local _DEFORM_R_ON
			#pragma shader_feature_local _DEFORM_G_ON
			#pragma shader_feature_local _DEFORM_B_ON
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
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Deformer;
			uniform float4 _Deformer_ST;
			uniform float _DeformVCol_or_Manual;
			uniform float _Deform;
			uniform float _DeformMult;
			uniform sampler2D _Normal;
			uniform float _Highlight;
			uniform float4 _ColorLight;
			uniform float _LightedIntensity;
			uniform float _InvertStainMask;
			uniform float _Hardness;
			uniform float _Radius;
			uniform sampler2D _StainNoise;
			uniform float4 _StainNoise_ST;
			uniform float4 _DetailColor;
			uniform sampler2D _MainTexture;
			uniform float4 _MainTexture_ST;
			uniform float4 _Colorize;
			uniform float _StainIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv_Deformer = v.ase_texcoord.xy * _Deformer_ST.xy + _Deformer_ST.zw;
				float4 tex2DNode403 = tex2Dlod( _Deformer, float4( uv_Deformer, 0, 0.0) );
				#ifdef _DEFORM_R_ON
				float staticSwitch423 = tex2DNode403.r;
				#else
				float staticSwitch423 = 0.0;
				#endif
				#ifdef _DEFORM_G_ON
				float staticSwitch422 = tex2DNode403.g;
				#else
				float staticSwitch422 = 0.0;
				#endif
				#ifdef _DEFORM_B_ON
				float staticSwitch421 = tex2DNode403.b;
				#else
				float staticSwitch421 = 0.0;
				#endif
				float temp_output_424_0 = ( staticSwitch423 + staticSwitch422 + staticSwitch421 );
				float clampResult449 = clamp( v.color.r , 0.0 , 1.0 );
				float temp_output_410_0 = ( temp_output_424_0 * (( _DeformVCol_or_Manual )?( clampResult449 ):( _Deform )) );
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( temp_output_410_0 * v.ase_normal ) * _DeformMult );
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
				float clampResult340 = clamp( _LightedIntensity , 0.12 , 1.0 );
				float2 uv_StainNoise = i.ase_texcoord1.xy * _StainNoise_ST.xy + _StainNoise_ST.zw;
				float4 tex2DNode373 = tex2D( _StainNoise, uv_StainNoise );
				#ifdef _STAIN_R_ON
				float staticSwitch378 = tex2DNode373.r;
				#else
				float staticSwitch378 = 0.0;
				#endif
				#ifdef _STAIN_G_ON
				float staticSwitch380 = tex2DNode373.g;
				#else
				float staticSwitch380 = 0.0;
				#endif
				#ifdef _STAIN_B_ON
				float staticSwitch381 = tex2DNode373.b;
				#else
				float staticSwitch381 = 0.0;
				#endif
				float smoothstepResult212 = smoothstep( ( _Hardness * _Radius ) , _Radius , ( staticSwitch378 + staticSwitch380 + staticSwitch381 ));
				float temp_output_246_0 = saturate( smoothstepResult212 );
				float2 uv_MainTexture = i.ase_texcoord1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float clampResult449 = clamp( i.ase_color.r , 0.0 , 1.0 );
				float DeformValue425 = (( _DeformVCol_or_Manual )?( clampResult449 ):( _Deform ));
				float temp_output_445_0 = ( _StainIntensity * DeformValue425 * 5.0 );
				float4 temp_cast_0 = (saturate( ( (( _InvertStainMask )?( ( 1.0 - temp_output_246_0 ) ):( temp_output_246_0 )) * ( temp_output_445_0 * 0.5 ) ) )).xxxx;
				float4 blendOpSrc401 = saturate( ( (( _InvertStainMask )?( ( 1.0 - temp_output_246_0 ) ):( temp_output_246_0 )) * _DetailColor ) );
				float4 blendOpDest401 = saturate( ( saturate( ( tex2D( _MainTexture, uv_MainTexture ) * _Colorize ) ) - temp_cast_0 ) );
				float clampResult448 = clamp( temp_output_445_0 , 0.0 , 1.0 );
				float4 lerpBlendMode401 = lerp(blendOpDest401,( 1.0 - ( 1.0 - blendOpSrc401 ) * ( 1.0 - blendOpDest401 ) ),clampResult448);
				float4 break426 = ( ( saturate( ( smoothstepResult234 + ( tex2DNode229.b * 0.025 * ( 1.0 - texCoord230.y ) ) ) ) * _ColorLight * clampResult340 ) + saturate( ( saturate( lerpBlendMode401 )) ) );
				float2 uv_Deformer = i.ase_texcoord1.xy * _Deformer_ST.xy + _Deformer_ST.zw;
				float4 tex2DNode403 = tex2D( _Deformer, uv_Deformer );
				#ifdef _DEFORM_R_ON
				float staticSwitch423 = tex2DNode403.r;
				#else
				float staticSwitch423 = 0.0;
				#endif
				#ifdef _DEFORM_G_ON
				float staticSwitch422 = tex2DNode403.g;
				#else
				float staticSwitch422 = 0.0;
				#endif
				#ifdef _DEFORM_B_ON
				float staticSwitch421 = tex2DNode403.b;
				#else
				float staticSwitch421 = 0.0;
				#endif
				float temp_output_424_0 = ( staticSwitch423 + staticSwitch422 + staticSwitch421 );
				float temp_output_441_0 = ( 1.0 - saturate( temp_output_424_0 ) );
				float smoothstepResult437 = smoothstep( ( ( (( _DeformVCol_or_Manual )?( clampResult449 ):( _Deform )) * 0.7 ) * temp_output_441_0 ) , 1.0 , temp_output_441_0);
				float temp_output_410_0 = ( temp_output_424_0 * (( _DeformVCol_or_Manual )?( clampResult449 ):( _Deform )) );
				float4 appendResult427 = (float4(break426.r , break426.g , break426.b , saturate( ( ( smoothstepResult437 - (( _DeformVCol_or_Manual )?( clampResult449 ):( _Deform )) ) / temp_output_410_0 ) )));
				
				
				finalColor = saturate( appendResult427 );
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
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2757.433,689.9656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-841.2159,216.237;Inherit;False;Property;_Colorize;Colorize;3;1;[HDR];Create;True;0;0;0;False;0;False;0.8396226,0.6693218,0.6693218,0;1.668057,1.668057,1.668057,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2490.416,713.0248;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;384;-504.8445,1173.849;Inherit;False;Property;_Radius;Radius;2;0;Create;True;0;0;0;False;0;False;0.4;1.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-971.9001,-233.0901;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;bfd675cc0db1d4656b75dc6d6ba91142;50dba9ba2dc14f94492be611c2367303;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;383;-599.6992,1089.826;Inherit;False;Property;_Hardness;Hardness;6;0;Create;True;0;0;0;False;0;False;0.3;0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;101;564.9113,-25.09914;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;210;1058.671,470.6352;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;398;152.3974,669.4267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;397;295.7975,426.6262;Inherit;False;Property;_InvertStainMask;InvertStainMask;17;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;399;1235.362,187.8471;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;389;965.6597,181.2368;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;371;-1184.489,536.457;Inherit;False;0;373;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;372;-1458.884,594.5468;Inherit;False;373;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;373;-969.1318,487.4363;Inherit;True;Property;_StainNoise;StainNoise;1;0;Create;True;0;0;0;False;0;False;-1;07fa516b0750c334e9fabd819eb77002;07fa516b0750c334e9fabd819eb77002;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;370;-1580.952,-140.045;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;368;-1301.869,-198.1348;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;387;-879.0243,946.7371;Inherit;False;Constant;_Nul;Nul;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;381;-589.2102,762.9172;Inherit;True;Property;_Stain_B;Stain_B;15;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;380;-603.0147,659.5829;Inherit;False;Property;_Stain_G;Stain_G;13;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;378;-599.6395,428.2624;Inherit;True;Property;_Stain_R;Stain_R;11;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;420;753.946,1756.578;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;426;3225.491,844.7076;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;427;3745.502,842.6845;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;206;175.8189,762.6412;Inherit;False;Property;_DetailColor;DetailColor;4;1;[HDR];Create;True;0;0;0;False;0;False;0.5660378,0,0.009433819,1;0.2641509,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;414;287.8297,1318.772;Inherit;False;0;403;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;448;601.1525,1139.896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;457;1797.661,1133.624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;411;2995.252,1668.452;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;403;566.7405,1318.174;Inherit;True;Property;_Deformer;Deformer;18;0;Create;True;0;0;0;False;0;False;-1;138dff2decdf168479497897cb336dd6;7cf6afe4105669349bd222f33ba5795d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;451;1630.736,2252.753;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;412;2731.284,1814.221;Inherit;False;Property;_DeformMult;DeformMult;21;0;Create;True;0;0;0;False;0;False;0;0.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;413;-16.29617,1277.505;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;2467.604,1695.886;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;459;2391.09,1553.929;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;423;1040.338,1279.615;Inherit;False;Property;_Deform_R;Deform_R;12;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;422;1043.154,1379.942;Inherit;False;Property;_Deform_G;Deform_G;14;0;Create;True;0;0;0;False;0;False;0;1;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;421;1038.313,1512.281;Inherit;True;Property;_Deform_B;Deform_B;16;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;441;1651.26,1244.428;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;442;1512.786,1327.571;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;424;1358.806,1379.798;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;1538.799,1138.8;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;450;1174.067,2145.255;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;408;638.7522,2026.407;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;449;910.7673,2051.854;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;425;1441.997,1984.456;Inherit;False;DeformValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;409;1175.83,1887.573;Inherit;False;Property;_DeformVCol_or_Manual;DeformVCol_or_Manual;19;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;458;3963.139,844.8827;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;1455.095,-64.37054;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.025;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2490.744,423.3035;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;221;2248.293,446.1898;Inherit;False;Property;_ColorLight;ColorLight;5;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.2730509,0.5282276,0.9811321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;227;2305.576,361.4809;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;2062.114,219.5716;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;664.0667,-666.4374;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;229;973.4658,-662.5369;Inherit;True;Property;_Normal;Normal;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;1388.167,-588.4373;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;1827.935,-119.7476;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;233;1619.039,-424.5048;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;220;426.0415,-460.3569;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;460;3296.639,1291.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;434;2568.354,1117.106;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;437;2159.458,1107.447;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;407;919.4348,1960.571;Inherit;False;Property;_Deform;Deform;20;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;436;3037.953,1293.86;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;2042.276,1362.808;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;-286.7036,574.6261;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;-177.5171,863.3825;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;-339.7169,895.4627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;246;-27.36002,404.5589;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;98.1321,988.209;Inherit;False;Property;_StainIntensity;StainIntensity;9;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;444;71.96536,1080.843;Inherit;False;425;DeformValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;447;120.7732,1156.33;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;445;397.5029,1030.959;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;659.5464,763.6708;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;402;381.6619,624.147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;396;820.1967,257.026;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;601.2968,348.526;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;401;1515.363,715.5466;Inherit;True;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;211;2048.357,708.24;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;338;1987.057,965.7198;Inherit;False;Property;_LightedIntensity;LightedIntensity;10;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;340;2308.259,846.8604;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;226;1348.837,-392.874;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;1030.025,-253.0177;Inherit;False;Property;_Highlight;Highlight;8;0;Create;True;0;0;0;False;0;False;1;1.138;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;966.5026,-15.69564;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;4712.965,1002.499;Float;False;True;-1;2;ASEMaterialInspector;100;5;Cortopia/VFX/ase_vfx_skinshell_break;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;223;0;222;0
WireConnection;223;1;211;0
WireConnection;5;1;368;0
WireConnection;101;0;24;0
WireConnection;210;0;207;0
WireConnection;398;0;246;0
WireConnection;397;0;246;0
WireConnection;397;1;398;0
WireConnection;399;0;389;0
WireConnection;389;0;101;0
WireConnection;389;1;396;0
WireConnection;371;0;372;0
WireConnection;371;1;372;1
WireConnection;368;0;370;0
WireConnection;368;1;370;1
WireConnection;381;1;387;0
WireConnection;381;0;373;3
WireConnection;380;1;387;0
WireConnection;380;0;373;2
WireConnection;378;1;387;0
WireConnection;378;0;373;1
WireConnection;426;0;223;0
WireConnection;427;0;426;0
WireConnection;427;1;426;1
WireConnection;427;2;426;2
WireConnection;427;3;460;0
WireConnection;414;0;413;0
WireConnection;414;1;413;1
WireConnection;448;0;445;0
WireConnection;457;0;443;0
WireConnection;457;1;441;0
WireConnection;411;0;419;0
WireConnection;411;1;412;0
WireConnection;403;1;414;0
WireConnection;419;0;410;0
WireConnection;419;1;451;0
WireConnection;459;0;409;0
WireConnection;423;1;420;0
WireConnection;423;0;403;1
WireConnection;422;1;420;0
WireConnection;422;0;403;2
WireConnection;421;1;420;0
WireConnection;421;0;403;3
WireConnection;441;0;442;0
WireConnection;442;0;424;0
WireConnection;424;0;423;0
WireConnection;424;1;422;0
WireConnection;424;2;421;0
WireConnection;443;0;409;0
WireConnection;450;0;449;0
WireConnection;449;0;408;1
WireConnection;425;0;409;0
WireConnection;409;0;407;0
WireConnection;409;1;449;0
WireConnection;458;0;427;0
WireConnection;240;0;229;3
WireConnection;240;2;243;0
WireConnection;222;0;227;0
WireConnection;222;1;221;0
WireConnection;222;2;340;0
WireConnection;227;0;242;0
WireConnection;242;0;234;0
WireConnection;242;1;240;0
WireConnection;229;1;230;0
WireConnection;235;0;229;2
WireConnection;234;0;233;0
WireConnection;233;0;235;0
WireConnection;233;1;226;0
WireConnection;460;0;436;0
WireConnection;434;0;437;0
WireConnection;434;1;459;0
WireConnection;437;0;441;0
WireConnection;437;1;457;0
WireConnection;436;0;434;0
WireConnection;436;1;410;0
WireConnection;410;0;424;0
WireConnection;410;1;409;0
WireConnection;390;0;378;0
WireConnection;390;1;380;0
WireConnection;390;2;381;0
WireConnection;212;0;390;0
WireConnection;212;1;385;0
WireConnection;212;2;384;0
WireConnection;385;0;383;0
WireConnection;385;1;384;0
WireConnection;246;0;212;0
WireConnection;445;0;209;0
WireConnection;445;1;444;0
WireConnection;445;2;447;0
WireConnection;207;0;397;0
WireConnection;207;1;206;0
WireConnection;402;0;445;0
WireConnection;396;0;392;0
WireConnection;392;0;397;0
WireConnection;392;1;402;0
WireConnection;401;0;210;0
WireConnection;401;1;399;0
WireConnection;401;2;448;0
WireConnection;211;0;401;0
WireConnection;340;0;338;0
WireConnection;226;0;220;2
WireConnection;226;1;258;0
WireConnection;243;0;230;2
WireConnection;257;0;458;0
WireConnection;257;1;411;0
ASEEND*/
//CHKSM=6C2E7B6C62901C792C845255C6BC84F29E10F6E8