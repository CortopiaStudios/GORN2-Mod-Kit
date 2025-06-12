// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_fire_mesh_1"
{
	Properties
	{
		[HDR]_ColorGlow("ColorGlow", Color) = (0.6603774,0.1211995,0,0.7882353)
		[HDR]_ColorBase("ColorBase", Color) = (0.3820755,0.5100812,1,1)
		_Shaper("Shaper", Range( 0 , 50)) = 14.46381
		_Fresnel("Fresnel", Range( 0 , 1)) = 1
		_Speed2("Speed2", Range( -1 , 1)) = 0
		_Speed1("Speed1", Range( -1 , 1)) = 0
		_AlphaNoiseSpeed("AlphaNoiseSpeed", Range( -1 , 1)) = 0.5233154
		_Deform("Deform", 2D) = "black" {}
		_OffsetZ("OffsetZ", Range( -4 , 4)) = 0
		_OffsetX("OffsetX", Range( -4 , 4)) = 0
		_AlphaNosie("AlphaNosie", 2D) = "white" {}
		[Toggle]_Deform_Mask_Invert1("Deform_Mask_Invert1", Float) = 0
		[Toggle]_Deform_Mask_Invert2("Deform_Mask_Invert2", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Sidecut("Sidecut", Range( -1 , 5)) = 0.4153337
		_SidecutBoost("SidecutBoost", Range( -1 , 5)) = 0.4153337
		[Toggle]_InvertSidecut("InvertSidecut", Float) = 1
		_SidecutPan("SidecutPan", Range( -10 , 10)) = 5
		_ShreddingVert("ShreddingVert", Float) = -2.23

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha
		AlphaToMask On
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
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION


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

			uniform float _Deform_Mask_Invert1;
			uniform sampler2D _Deform;
			uniform float _Speed1;
			uniform float4 _Deform_ST;
			uniform float _OffsetX;
			uniform float _Deform_Mask_Invert2;
			uniform float _Speed2;
			uniform float _OffsetZ;
			uniform float _Shaper;
			uniform float4 _ColorBase;
			uniform sampler2D _AlphaNosie;
			uniform float _AlphaNoiseSpeed;
			uniform float4 _AlphaNosie_ST;
			uniform float _ShreddingVert;
			uniform float4 _ColorGlow;
			uniform float _Fresnel;
			uniform float _InvertSidecut;
			uniform sampler2D _TextureSample0;
			uniform float _SidecutPan;
			uniform float4 _TextureSample0_ST;
			uniform float _Sidecut;
			uniform float _SidecutBoost;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 texCoord521 = v.ase_texcoord.xy * float2( -0.2,2 ) + float2( -0.1,-0.07 );
				float clampResult697 = clamp( saturate( ( texCoord521.y * 0.1 ) ) , 0.0 , 0.04 );
				float2 appendResult631 = (float2(0.0 , 1.0));
				float2 uv_Deform = v.ase_texcoord.xy * _Deform_ST.xy + _Deform_ST.zw;
				float2 panner633 = ( -1.0 * _Time.y * ( appendResult631 * _Speed1 ) + uv_Deform);
				float4 tex2DNode574 = tex2Dlod( _Deform, float4( (panner633*0.85 + 0.5), 0, 0.0) );
				float temp_output_626_0 = ( (( _Deform_Mask_Invert1 )?( ( 1.0 - tex2DNode574.g ) ):( tex2DNode574.g )) + _OffsetX );
				float2 appendResult562 = (float2(0.0 , 1.0));
				float2 texCoord711 = v.ase_texcoord.xy * float2( 0,0.5 ) + float2( 0,0 );
				float2 panner566 = ( -1.0 * _Time.y * ( appendResult562 * _Speed2 ) + texCoord711);
				float4 tex2DNode571 = tex2Dlod( _Deform, float4( (panner566*1.0 + 0.0), 0, 0.0) );
				float temp_output_625_0 = ( (( _Deform_Mask_Invert2 )?( ( 1.0 - tex2DNode571.r ) ):( tex2DNode571.r )) + _OffsetZ );
				float3 appendResult576 = (float3(temp_output_626_0 , 1.0 , temp_output_625_0));
				float3 break584 = ( clampResult697 * (float3( -1,0,-1 ) + (appendResult576 - float3( 0,0,0 )) * (float3( 1,1,1 ) - float3( -1,0,-1 )) / (float3( 1,1,1 ) - float3( 0,0,0 ))) );
				float3 appendResult575 = (float3(v.vertex.xyz.x , v.vertex.xyz.y , v.vertex.xyz.z));
				float3 appendResult577 = (float3(v.ase_normal.x , v.ase_normal.y , v.ase_normal.z));
				float3 break583 = (float3( -1,0,-1 ) + (( appendResult575 * ( appendResult577 / float3( 2,2,2 ) ) ) - float3( 0,0,0 )) * (float3( 1,1,1 ) - float3( -1,0,-1 )) / (float3( 1,1,1 ) - float3( 0,0,0 )));
				float3 appendResult587 = (float3(( break584.x * break583.x ) , ( break584.y * break583.y ) , ( break584.z * break583.z )));
				
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
				vertexValue = ( appendResult587 * _Shaper );
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
				float2 appendResult657 = (float2(0.0 , 1.0));
				float2 uv_AlphaNosie = i.ase_texcoord1.xy * _AlphaNosie_ST.xy + _AlphaNosie_ST.zw;
				float2 panner659 = ( 1.0 * _Time.y * ( appendResult657 * _AlphaNoiseSpeed ) + uv_AlphaNosie);
				float2 appendResult791 = (float2(0.0 , _ShreddingVert));
				float2 texCoord652 = i.ase_texcoord1.xy * float2( 1,3 ) + appendResult791;
				float temp_output_651_0 = ( tex2D( _AlphaNosie, panner659 ).r * texCoord652.y );
				float ColTransition685 = temp_output_651_0;
				float2 texCoord707 = i.ase_texcoord1.xy * float2( 1,0.7 ) + float2( 0,0.26 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float temp_output_555_0 = ( _Fresnel * 1.0 );
				float fresnelNdotV526 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode526 = ( ( _Fresnel * 0.2 ) + 1.07 * pow( max( 1.0 - fresnelNdotV526 , 0.0001 ), temp_output_555_0 ) );
				float4 blendOpSrc667 = _ColorBase;
				float4 blendOpDest667 = ( ( ( 1.0 - ColTransition685 ) * ( 1.0 - texCoord707.y ) ) * ( _ColorGlow * ( 1.0 - saturate( fresnelNode526 ) ) ) );
				float2 texCoord680 = i.ase_texcoord1.xy * float2( 1,0.24 ) + float2( 0,0.05 );
				float temp_output_688_0 = saturate( ( ( ( 1.0 - texCoord680.y ) * texCoord680.y ) * 4.84 ) );
				float temp_output_692_0 = ( 1.0 - temp_output_688_0 );
				float4 lerpBlendMode667 = lerp(blendOpDest667,( blendOpSrc667 + blendOpDest667 ),saturate( ( temp_output_692_0 - ( ColTransition685 * temp_output_688_0 * _ColorGlow.a ) ) ));
				float4 temp_output_667_0 = lerpBlendMode667;
				float4 break617 = temp_output_667_0;
				float2 appendResult786 = (float2(0.0 , _SidecutPan));
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float2 panner740 = ( 1.0 * _Time.y * appendResult786 + uv_TextureSample0);
				float4 tex2DNode733 = tex2D( _TextureSample0, panner740 );
				float temp_output_729_0 = ( (( _InvertSidecut )?( ( 1.0 - tex2DNode733.r ) ):( tex2DNode733.r )) * _Sidecut );
				float temp_output_3_0_g5 = ( temp_output_692_0 - temp_output_729_0 );
				float lerpResult730 = lerp( temp_output_729_0 , ( 1.0 - saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) ) , 1.0);
				float Sidehustle735 = ( ( 1.0 - lerpResult730 ) * _SidecutBoost );
				float temp_output_618_0 = saturate( ( Sidehustle735 * ( saturate( break617.a ) - temp_output_651_0 ) ) );
				float4 appendResult619 = (float4(break617.r , break617.g , break617.b , temp_output_618_0));
				float smoothstepResult654 = smoothstep( 0.5 , 0.9 , temp_output_618_0);
				
				
				finalColor = saturate( ( appendResult619 * ( saturate( smoothstepResult654 ) * 5.0 ) ) );
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
Node;AmplifyShaderEditor.CommentaryNode;559;-57.81531,2463.468;Inherit;False;3931.117;1362.341;Comment;48;599;595;589;587;586;585;584;583;581;580;579;577;576;575;574;573;572;571;570;569;568;566;565;564;563;562;561;560;602;603;605;612;624;625;626;627;630;632;628;629;631;633;695;696;698;701;700;711;Deform;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;575;1881.385,3116.66;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;583;2839.344,2860.249;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;604;1472.47,994.6943;Inherit;False;Aimer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;584;2837.521,2707.812;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;586;3024.102,2707.73;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;602;3039.263,2802.642;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;585;3043.938,2900.812;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;587;3210.42,2774.986;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;589;3122.051,3233.449;Inherit;False;Property;_Shaper;Shaper;2;0;Create;True;0;0;0;False;0;False;14.46381;14.9;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;553;2791.777,689.1085;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;539;1938.029,1246.083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;555;1835.077,1391.508;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;611;2075.248,424.0114;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;538;1728.628,1266.883;Inherit;False;Constant;_AimValue;AimValue;6;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;2202.649,544.9113;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;554;1678.677,1442.208;Inherit;False;Constant;_Float;Float;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;608;1784.048,386.3114;Inherit;False;604;Aimer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;548;2431.665,1340.808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;605;3103.754,3461.079;Inherit;False;604;Aimer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;603;3486.711,3381.459;Inherit;False;2;2;0;FLOAT;4;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;523;1912.87,1866.035;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;599;3607.951,2915.48;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;628;-14.61536,2690.253;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;1321.299,2767.335;Inherit;False;Property;_OffsetX;OffsetX;9;0;Create;True;0;0;0;False;0;False;0;0.26;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;581;2608.593,2668.009;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;612;3290.789,3404.801;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;648;1853.739,2299.753;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;651;4033.584,1539.215;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;646;4142.893,1135.355;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;629;-21.26132,2612.021;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;630;43.81885,2767.538;Inherit;False;Property;_Speed1;Speed1;5;0;Create;True;0;0;0;False;0;False;0;0.41;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;631;187.5417,2665.823;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;632;349.7908,2716.011;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;633;534.5165,2789.363;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;574;1348.374,2548.331;Inherit;True;Property;_TextureSample4;Texture Sample 4;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;619;4773.324,750.4528;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;668;2515.818,2267.755;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;669;3092.298,1326.873;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;551;2422.306,502.1066;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.89;False;2;FLOAT;0.12;False;3;FLOAT;0.29;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;351;3707.357,1037.331;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;552;2950.484,852.1557;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;681;1791.888,63.49341;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;682;1999.887,-112.5065;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;687;2536.821,-378.0687;Inherit;True;685;ColTransition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;691;3232.098,9.140039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;607;2994.68,248.6959;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;606;2309.969,211.4055;Inherit;False;Property;_ColorBase;ColorBase;1;1;[HDR];Create;True;0;0;0;False;0;False;0.3820755,0.5100812,1,1;3.482202,0.131129,0,0.6509804;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;653;4222.977,1358.442;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;577;1876.153,3368.916;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;579;2145.96,3181.04;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;572;1528.877,3425.094;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;573;1466.42,3220.502;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;696;2505.264,2978.315;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;3;FLOAT3;-1,0,-1;False;4;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;571;1286.868,2857.472;Inherit;True;Property;_TextureSample5;Texture Sample 5;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;624;1301.904,3090.463;Inherit;False;Property;_OffsetZ;OffsetZ;8;0;Create;True;0;0;0;False;0;False;0;0.39;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;625;1863.299,2980.335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;700;1605.212,2850.457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;699;1603.712,2353.457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;701;1600.212,2929.457;Inherit;False;Property;_Deform_Mask_Invert2;Deform_Mask_Invert2;12;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;580;2374.062,2766.423;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;3;FLOAT3;-1,0,-1;False;4;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;692;2787.799,37.34005;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;702;2957.777,-187.3919;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;690;2736.298,-234.26;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;688;2327.898,62.74003;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;685;4347.565,1644.572;Inherit;False;ColTransition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;617;3931.025,749.1526;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;705;1538.279,516.2328;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;1230.363,416.4017;Inherit;True;685;ColTransition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;708;1769.272,741.0433;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;707;1301.272,717.0433;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.7;False;1;FLOAT2;0,0.26;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;709;1564.272,819.0433;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;413;2093.031,944.1345;Inherit;False;Property;_ColorGlow;ColorGlow;0;1;[HDR];Create;True;0;0;0;False;0;False;0.6603774,0.1211995,0,0.7882353;1.498039,0.5012507,0.1201258,0.1921569;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;710;2266.237,814.4099;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;680;1485.386,-161.5067;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.24;False;1;FLOAT2;0,0.05;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;698;1718.21,2590.61;Inherit;False;Property;_Deform_Mask_Invert1;Deform_Mask_Invert1;11;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;576;2117.264,2890.598;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;626;1978.299,2656.335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;561;8.830673,3227.829;Inherit;False;Constant;_Float8;Float 8;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;560;2.18469,3149.597;Inherit;False;Constant;_Float9;Float 9;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;562;210.9877,3203.399;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;565;373.2368,3253.587;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;563;67.26487,3305.114;Inherit;False;Property;_Speed2;Speed2;4;0;Create;True;0;0;0;False;0;False;0;0.22;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;564;269.3255,2860.277;Inherit;False;0;569;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;595;-31.80452,2867.146;Inherit;False;569;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.PannerNode;566;579.9625,3153.939;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;711;268.2294,3033.524;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;569;936.545,3020.773;Inherit;True;Property;_Deform;Deform;7;0;Create;True;0;0;0;False;0;False;f644a77509d7115418578d7f75059191;204cd928e761305469a2ef1af3831454;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ScaleAndOffsetNode;568;901.993,2802.069;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;570;900.0968,2582.165;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.85;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;1592.107,1880.721;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;521;1265.381,1830.213;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-0.2,2;False;1;FLOAT2;-0.1,-0.07;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;728;2154.542,-796.1136;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;703;4167.583,892.0342;Inherit;False;735;Sidehustle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;755;1261.432,-735.6439;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;730;2361.67,-959.6991;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;754;936.432,-708.6439;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;777;698.1364,-918.0112;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;780;704.1364,-1130.011;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;768;365.1364,-816.0112;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;5.19;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;781;947.1364,-1043.011;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NormalVertexDataNode;775;231.1364,-1121.011;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;784;1527.136,-1386.011;Inherit;False;Property;_InvertSidecut;InvertSidecut;16;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;729;1615.162,-957.1261;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;733;845.6295,-1507.534;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;0;False;0;False;-1;278a58f6d52875c4e9adfe3404fb480e;d9b00f9080da18441b15f07b1a704d8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;785;107.3812,-1464.355;Inherit;False;Property;_SidecutPan;SidecutPan;17;0;Create;True;0;0;0;False;0;False;5;-0.8;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;786;450.3813,-1438.355;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;783;1362.136,-1326.711;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;748;230.5324,-1274.744;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;782;1096.736,-1087.012;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;734;409.7616,-1662.423;Inherit;False;0;733;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0.5,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;739;118.5187,-1769.17;Inherit;False;733;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.PannerNode;740;598.7028,-1526.898;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;695;2024.264,3282.315;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;2,2,2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;655;2583.835,2024.006;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;663;3805.988,1997.488;Inherit;True;Property;_AlphaNosie;AlphaNosie;10;0;Create;True;0;0;0;False;0;False;-1;21b46c6e6bfb16e4abfced00ad9152cd;dfefd45a87f80d344ad079e21d5da47c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;656;2648.916,2179.523;Inherit;False;Property;_AlphaNoiseSpeed;AlphaNoiseSpeed;6;0;Create;True;0;0;0;False;0;False;0.5233154;-0.763;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;661;3232.989,2240.488;Inherit;False;0;663;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;662;3000.989,2323.488;Inherit;False;663;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;658;2954.887,2127.996;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;659;3553.614,2128.348;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;657;2792.638,2077.808;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;667;3418.7,674.212;Inherit;True;LinearDodge;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;549;2416.617,1132.822;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;537;1158.599,1018.14;Inherit;False;Property;_Fresnel;Fresnel;3;0;Create;True;0;0;0;False;0;False;1;0.856;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;683;1976.586,123.3426;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;727;1880.094,-762.1507;Inherit;True;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;723;1243.327,-416.569;Inherit;False;Property;_Sidecut;Sidecut;14;0;Create;True;0;0;0;False;0;False;0.4153337;0.76;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;787;1618.116,-397.9877;Inherit;False;Property;_SidecutBoost;SidecutBoost;15;0;Create;True;0;0;0;False;0;False;0.4153337;0.67;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;737;2694.154,-801.0445;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;735;2994.849,-757.8677;Inherit;False;Sidehustle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;788;2901.83,-577.5975;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;618;4592.701,1126.143;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;736;4365.607,942.9814;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;526;2116.447,1352.754;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.52;False;2;FLOAT;1.07;False;3;FLOAT;0.38;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;556;1976.378,1546.208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;414;2666.758,1051.609;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;697;2158.712,2095.457;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;615;6503.396,2655.483;Float;False;True;-1;2;ASEMaterialInspector;100;5;Cortopia/VFX/ase_vfx_fire_mesh_1;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638334135584225973;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;789;3207.049,1864.135;Inherit;False;Property;_ShreddingVert;ShreddingVert;18;0;Create;True;0;0;0;False;0;False;-2.23;-1.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;790;3197.34,1755.397;Inherit;False;Constant;_Float3;Float 3;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;791;3437.34,1821.397;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;666;5009.237,1359.355;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;664;5344.729,916.6935;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;792;5149.357,1226.895;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;693;5730.025,1364.299;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;654;4771.936,1358.661;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;652;3656.482,1648.421;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,3;False;1;FLOAT2;0,-0.07;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;575;0;573;1
WireConnection;575;1;573;2
WireConnection;575;2;573;3
WireConnection;583;0;696;0
WireConnection;604;0;537;0
WireConnection;584;0;581;0
WireConnection;586;0;584;0
WireConnection;586;1;583;0
WireConnection;602;0;584;1
WireConnection;602;1;583;1
WireConnection;585;0;584;2
WireConnection;585;1;583;2
WireConnection;587;0;586;0
WireConnection;587;1;602;0
WireConnection;587;2;585;0
WireConnection;553;0;551;0
WireConnection;539;0;537;0
WireConnection;539;1;538;0
WireConnection;555;0;537;0
WireConnection;555;1;554;0
WireConnection;611;0;608;0
WireConnection;610;0;611;0
WireConnection;548;0;526;0
WireConnection;603;0;589;0
WireConnection;603;1;612;0
WireConnection;523;0;522;0
WireConnection;599;0;587;0
WireConnection;599;1;589;0
WireConnection;581;0;697;0
WireConnection;581;1;580;0
WireConnection;612;0;605;0
WireConnection;648;0;574;3
WireConnection;651;0;663;1
WireConnection;651;1;652;2
WireConnection;646;0;617;3
WireConnection;631;0;629;0
WireConnection;631;1;628;0
WireConnection;632;0;631;0
WireConnection;632;1;630;0
WireConnection;633;0;564;0
WireConnection;633;2;632;0
WireConnection;574;0;569;0
WireConnection;574;1;570;0
WireConnection;619;0;617;0
WireConnection;619;1;617;1
WireConnection;619;2;617;2
WireConnection;619;3;618;0
WireConnection;668;0;626;0
WireConnection;668;1;625;0
WireConnection;669;0;351;0
WireConnection;669;1;668;0
WireConnection;551;1;610;0
WireConnection;351;0;667;0
WireConnection;552;0;553;0
WireConnection;681;0;680;2
WireConnection;682;0;681;0
WireConnection;682;1;680;2
WireConnection;691;0;702;0
WireConnection;607;0;606;0
WireConnection;607;1;553;0
WireConnection;653;0;646;0
WireConnection;653;1;651;0
WireConnection;577;0;572;1
WireConnection;577;1;572;2
WireConnection;577;2;572;3
WireConnection;579;0;575;0
WireConnection;579;1;695;0
WireConnection;696;0;579;0
WireConnection;571;0;569;0
WireConnection;571;1;568;0
WireConnection;625;0;701;0
WireConnection;625;1;624;0
WireConnection;700;0;571;1
WireConnection;699;0;574;2
WireConnection;701;0;571;1
WireConnection;701;1;700;0
WireConnection;580;0;576;0
WireConnection;692;0;688;0
WireConnection;702;0;692;0
WireConnection;702;1;690;0
WireConnection;690;0;687;0
WireConnection;690;1;688;0
WireConnection;690;2;413;4
WireConnection;688;0;683;0
WireConnection;685;0;651;0
WireConnection;617;0;667;0
WireConnection;705;0;704;0
WireConnection;708;0;705;0
WireConnection;708;1;709;0
WireConnection;709;0;707;2
WireConnection;710;0;708;0
WireConnection;710;1;414;0
WireConnection;698;0;574;2
WireConnection;698;1;699;0
WireConnection;576;0;626;0
WireConnection;576;2;625;0
WireConnection;626;0;698;0
WireConnection;626;1;627;0
WireConnection;562;0;560;0
WireConnection;562;1;561;0
WireConnection;565;0;562;0
WireConnection;565;1;563;0
WireConnection;564;0;595;0
WireConnection;564;1;595;1
WireConnection;566;0;711;0
WireConnection;566;2;565;0
WireConnection;568;0;566;0
WireConnection;570;0;633;0
WireConnection;522;0;521;2
WireConnection;728;0;727;0
WireConnection;755;0;768;0
WireConnection;730;0;729;0
WireConnection;730;1;728;0
WireConnection;754;0;768;0
WireConnection;777;0;748;0
WireConnection;777;1;775;0
WireConnection;780;0;748;0
WireConnection;780;1;775;0
WireConnection;781;0;780;0
WireConnection;784;0;733;1
WireConnection;784;1;783;0
WireConnection;729;0;784;0
WireConnection;729;1;723;0
WireConnection;733;1;740;0
WireConnection;786;1;785;0
WireConnection;783;0;733;1
WireConnection;782;0;781;0
WireConnection;734;0;739;0
WireConnection;734;1;739;1
WireConnection;740;0;734;0
WireConnection;740;2;786;0
WireConnection;695;0;577;0
WireConnection;663;1;659;0
WireConnection;661;0;662;0
WireConnection;661;1;662;1
WireConnection;658;0;657;0
WireConnection;658;1;656;0
WireConnection;659;0;661;0
WireConnection;659;2;658;0
WireConnection;657;0;655;0
WireConnection;667;0;606;0
WireConnection;667;1;710;0
WireConnection;667;2;691;0
WireConnection;549;0;548;0
WireConnection;683;0;682;0
WireConnection;727;1;729;0
WireConnection;727;2;692;0
WireConnection;737;0;730;0
WireConnection;735;0;788;0
WireConnection;788;0;737;0
WireConnection;788;1;787;0
WireConnection;618;0;736;0
WireConnection;736;0;703;0
WireConnection;736;1;653;0
WireConnection;526;1;539;0
WireConnection;526;3;555;0
WireConnection;556;0;555;0
WireConnection;414;0;413;0
WireConnection;414;1;549;0
WireConnection;697;0;523;0
WireConnection;615;0;693;0
WireConnection;615;1;599;0
WireConnection;791;0;790;0
WireConnection;791;1;789;0
WireConnection;666;0;654;0
WireConnection;664;0;619;0
WireConnection;664;1;792;0
WireConnection;792;0;666;0
WireConnection;693;0;664;0
WireConnection;654;0;618;0
WireConnection;652;1;791;0
ASEEND*/
//CHKSM=2E96AAA6AFDC8C6F90B5D515BA63B2CA967C75AF