// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_env_grillgrate_glow"
{
	Properties
	{
		[HideInInspector] _VTInfoBlock( "VT( auto )", Vector ) = ( 0, 0, 0, 0 )
		_EdgeGradient("EdgeGradient", 2D) = "white" {}
		_Fader("Fader", Range( 0 , 10)) = 7.897599
		[HDR]_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)
		[HDR]_Embers("Embers", Color) = (0.4669811,0.5426843,1,1)
		_EmberPan("EmberPan", Range( -1 , 1)) = 0.2170622
		_GlowBase("GlowBase", Range( 0 , 1)) = 1
		_EmberBase("EmberBase", Range( 0 , 10)) = 1
		_EmberBaseRisers("EmberBaseRisers", Range( 0 , 0.25)) = 1
		_EmberGlow("EmberGlow", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
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
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _EmberGlow;
			uniform half _EmberPan;
			uniform half4 _EmberGlow_ST;
			uniform half _EmberBase;
			uniform half _EmberBaseRisers;
			uniform half4 _Color0;
			uniform sampler2D _EdgeGradient;
			uniform half4 _EdgeGradient_ST;
			uniform half _GlowBase;
			uniform half4 _Embers;
			uniform half _Fader;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				half2 temp_cast_0 = (( 3.2 * _EmberPan )).xx;
				half2 uv_EmberGlow = v.ase_texcoord.xy * _EmberGlow_ST.xy + _EmberGlow_ST.zw;
				half2 panner538 = ( 0.3 * _Time.y * temp_cast_0 + uv_EmberGlow);
				half4 tex2DNode534 = tex2Dlod( _EmberGlow, float4( panner538, 0, 0.0) );
				half2 appendResult574 = (half2(0.0 , ( -2.0 * _EmberPan )));
				half2 panner508 = ( 0.3 * _Time.y * appendResult574 + uv_EmberGlow);
				half4 tex2DNode463 = tex2Dlod( _EmberGlow, float4( panner508, 0, 0.0) );
				half EmberGlow589 = ( ( tex2DNode534 + tex2DNode463 ) * _EmberBase * _EmberBaseRisers );
				half2 texCoord585 = v.ase_texcoord1.xy * float2( 1,2 ) + float2( 0,-0.12 );
				half3 appendResult553 = (half3(0.0 , ( EmberGlow589 * ( texCoord585.y * 2.0 ) ) , 0.0));
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = appendResult553;
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
				half2 temp_cast_0 = (( 3.2 * _EmberPan )).xx;
				half2 uv_EmberGlow = i.ase_texcoord1.xy * _EmberGlow_ST.xy + _EmberGlow_ST.zw;
				half2 panner538 = ( 0.3 * _Time.y * temp_cast_0 + uv_EmberGlow);
				half4 tex2DNode534 = tex2D( _EmberGlow, panner538 );
				half2 appendResult574 = (half2(0.0 , ( -2.0 * _EmberPan )));
				half2 panner508 = ( 0.3 * _Time.y * appendResult574 + uv_EmberGlow);
				half4 tex2DNode463 = tex2D( _EmberGlow, panner508 );
				half2 uv2_EdgeGradient = i.ase_texcoord1.zw * _EdgeGradient_ST.xy + _EdgeGradient_ST.zw;
				half4 tex2DNode464 = tex2D( _EdgeGradient, uv2_EdgeGradient );
				half temp_output_532_0 = ( ( tex2DNode534 * tex2DNode463 ) * _EmberBase * tex2DNode464.r );
				half temp_output_557_0 = saturate( ( temp_output_532_0 + ( tex2DNode464.r * _GlowBase ) ) );
				half2 texCoord550 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0.34 );
				half temp_output_588_0 = saturate( ( 1.0 - ( texCoord550.y * 0.97 ) ) );
				half2 texCoord578 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0.04 );
				half EmberGlowMultiplied548 = saturate( ( ( 1.0 - ( texCoord578.y * 1.0 ) ) * temp_output_532_0 ) );
				
				
				finalColor = saturate( ( ( ( saturate( ( _Color0 * temp_output_557_0 ) ) * temp_output_557_0 * temp_output_588_0 ) + ( _Embers * EmberGlowMultiplied548 ) ) * _Fader * temp_output_588_0 ) );
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
Node;AmplifyShaderEditor.CommentaryNode;609;-6858.983,931.2653;Inherit;False;1775.881;717.8812;Comment;9;467;468;469;466;482;530;465;529;464;baseglow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;608;-7204.961,-665.0345;Inherit;False;2822.754;1490.593;Comment;26;508;463;471;470;474;473;481;472;539;546;538;534;535;573;536;574;576;587;541;542;543;544;545;540;533;510;emberglow;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;553;-1795.276,2444.721;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;554;-2274.371,2906.217;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-682.7926,2124.298;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;569;-926.8914,1689.559;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;563;-2149.571,2231.878;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;572;-1822.705,1727.205;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;568;-2301.422,1559.288;Inherit;False;Property;_Embers;Embers;9;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;1.679245,0.3389807,0.1188145,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-2111.246,686.5261;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;515;-1748.821,726.8142;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;478;-2419.195,529.7513;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;1.523401,0.01405494,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;593;-2174.786,1060.92;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;592;-2254.797,1114.26;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;570;-1508.001,1204.153;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;532;-3668.549,398.004;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;578;-4040.127,-500.8218;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0.04;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;580;-3598.281,-173.1359;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;581;-3428.567,94.84018;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;579;-3843.696,-349.9539;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;577;-3090.985,141.7964;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;598;-3915.072,198.5536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;557;-3113.536,1167.534;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;602;-3765.079,608.7785;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;604;-4249.488,885.3691;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;603;-4134.368,637.186;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;531;-4180.833,391.224;Inherit;False;Property;_EmberBase;EmberBase;12;0;Create;True;0;0;0;False;0;False;1;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;590;-3640.182,647.9225;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;591;-4006.748,838.9777;Inherit;False;Property;_EmberBaseRisers;EmberBaseRisers;13;0;Create;True;0;0;0;False;0;False;1;0.0149;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;589;-2905.742,649.7732;Inherit;False;EmberGlow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;548;-2912.988,539.5821;Inherit;False;EmberGlowMultiplied;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;596;-4282.527,627.5139;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;607;-3985.902,179.5023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;605;-3890.736,717.6242;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;606;-3863.754,731.0118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;508;-5319.188,471.4495;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;463;-5046.75,434.4385;Inherit;True;Property;_EmberNoise;EmberNoise;0;0;Create;True;0;0;0;False;0;False;533;138dff2decdf168479497897cb336dd6;8c4a7fca2884fab419769ccc0355c0c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;471;-6767.278,497.7059;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;470;-6929.516,546.168;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;474;-7154.961,508.2419;Inherit;False;Property;_MaskU;MaskU;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;473;-7154.96,586.2001;Inherit;False;Property;_MaskV;MaskV;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;481;-6623.199,464.24;Inherit;False;0;533;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;472;-7149.013,376.1202;Inherit;False;463;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;539;-5651.352,-334.2383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;546;-5858.081,-332.7212;Inherit;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;0;False;0;False;3.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;538;-5348.929,-470.347;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;534;-5075.373,-275.5365;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;138dff2decdf168479497897cb336dd6;8c4a7fca2884fab419769ccc0355c0c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;535;-6196.228,542.0246;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;573;-6021.361,712.5587;Inherit;False;Constant;_Float4;Float 4;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;536;-6009.191,595.6099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;574;-5807.072,569.289;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;576;-4617.953,435.6106;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;587;-4615.207,111.9259;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;541;-6310.482,-450.5962;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;542;-6472.721,-402.1342;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;543;-6698.166,-440.0602;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;544;-6698.165,-362.102;Inherit;False;Property;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;545;-6652.375,-612.0226;Inherit;False;463;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;540;-6193.796,-615.0345;Inherit;False;0;533;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VirtualTextureObject;533;-5490.657,30.90838;Inherit;True;Property;_EmberGlow;EmberGlow;14;0;Create;True;0;0;0;False;0;False;-1;dfefd45a87f80d344ad079e21d5da47c;0cd65b01e70ed3d4db30773bf08c891b;False;white;Auto;Unity5;0;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;510;-6413.201,30.45413;Inherit;False;Property;_EmberPan;EmberPan;10;0;Create;True;0;0;0;False;0;False;0.2170622;-0.07;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;467;-6804.771,1458.188;Inherit;False;Property;_FlashU;FlashU;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;468;-6808.983,1536.146;Inherit;False;Property;_FlashV;FlashV;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;469;-6606.538,1494.114;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;466;-6472.31,1312.85;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;482;-6413.998,1091.711;Inherit;False;1;464;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;530;-5882.7,1480.347;Inherit;False;Property;_GlowBase;GlowBase;11;0;Create;True;0;0;0;False;0;False;1;0.86;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;465;-6791.509,1205.131;Inherit;False;464;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;529;-5261.103,1178.291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;464;-5834.358,981.2653;Inherit;True;Property;_EdgeGradient;EdgeGradient;0;0;Create;True;0;0;0;False;0;False;-1;9fe4c72364fb6754cb2f6590ddfc2fb1;9fe4c72364fb6754cb2f6590ddfc2fb1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;497;-3387.009,1167.265;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;585;-2802.834,3003.708;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,-0.12;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;547;-2788.12,2909.366;Inherit;False;589;EmberGlow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;584;-2532.233,3049.533;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;551;-2380.759,2218.91;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.97;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;550;-2616.575,2165.682;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0.34;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;588;-1734.496,2190.929;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;571;-2304.596,1752.212;Inherit;False;548;EmberGlowMultiplied;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1045.51,2107.081;Inherit;False;Property;_Fader;Fader;7;0;Create;True;0;0;0;False;0;False;7.897599;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;525;3.638869,2414.53;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_env_grillgrate_glow;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;516;-447.7441,2119.836;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;553;1;554;0
WireConnection;554;0;547;0
WireConnection;554;1;584;0
WireConnection;183;0;569;0
WireConnection;183;1;196;0
WireConnection;183;2;588;0
WireConnection;569;0;570;0
WireConnection;569;1;572;0
WireConnection;563;0;551;0
WireConnection;572;0;568;0
WireConnection;572;1;571;0
WireConnection;486;0;478;0
WireConnection;486;1;593;0
WireConnection;515;0;486;0
WireConnection;593;0;592;0
WireConnection;592;0;557;0
WireConnection;570;0;515;0
WireConnection;570;1;557;0
WireConnection;570;2;588;0
WireConnection;532;0;598;0
WireConnection;532;1;531;0
WireConnection;532;2;602;0
WireConnection;580;0;579;0
WireConnection;581;0;580;0
WireConnection;581;1;532;0
WireConnection;579;0;578;2
WireConnection;577;0;581;0
WireConnection;598;0;607;0
WireConnection;557;0;497;0
WireConnection;602;0;603;0
WireConnection;604;0;464;1
WireConnection;603;0;604;0
WireConnection;590;0;596;0
WireConnection;590;1;606;0
WireConnection;590;2;591;0
WireConnection;589;0;590;0
WireConnection;548;0;577;0
WireConnection;596;0;576;0
WireConnection;607;0;587;0
WireConnection;605;0;531;0
WireConnection;606;0;605;0
WireConnection;508;0;481;0
WireConnection;508;2;574;0
WireConnection;463;0;533;0
WireConnection;463;1;508;0
WireConnection;471;0;472;1
WireConnection;471;1;470;0
WireConnection;470;0;474;0
WireConnection;470;1;473;0
WireConnection;481;0;472;0
WireConnection;481;1;471;0
WireConnection;539;0;546;0
WireConnection;539;1;510;0
WireConnection;538;0;540;0
WireConnection;538;2;539;0
WireConnection;534;0;533;0
WireConnection;534;1;538;0
WireConnection;536;0;535;0
WireConnection;536;1;510;0
WireConnection;574;0;573;0
WireConnection;574;1;536;0
WireConnection;576;0;534;1
WireConnection;576;1;463;1
WireConnection;587;0;534;1
WireConnection;587;1;463;1
WireConnection;541;0;545;1
WireConnection;541;1;542;0
WireConnection;542;0;543;0
WireConnection;542;1;544;0
WireConnection;540;0;545;0
WireConnection;540;1;541;0
WireConnection;469;0;467;0
WireConnection;469;1;468;0
WireConnection;466;0;465;1
WireConnection;466;1;469;0
WireConnection;482;0;465;0
WireConnection;482;1;466;0
WireConnection;529;0;464;1
WireConnection;529;1;530;0
WireConnection;464;1;482;0
WireConnection;497;0;532;0
WireConnection;497;1;529;0
WireConnection;584;0;585;2
WireConnection;551;0;550;2
WireConnection;588;0;563;0
WireConnection;525;0;516;0
WireConnection;525;1;553;0
WireConnection;516;0;183;0
ASEEND*/
//CHKSM=5C4CAB7918E5CBCDC6C10D3B6AC54E34C79AB0DB