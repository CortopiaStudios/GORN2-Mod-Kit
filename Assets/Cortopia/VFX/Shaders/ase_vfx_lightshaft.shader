// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_lightshaft"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,0.3301923,1,0)
		_Add("Add", Color) = (0.2615309,0.1718138,0.3679245,0)
		[Toggle]_UVClampTop("UVClampTop", Float) = 0
		_Fill("Fill", Range( 0 , 2)) = 1.195647
		_Texture0("Texture 0", 2D) = "white" {}
		_ShadowTex("ShadowTex", 2D) = "white" {}
		_Fade("Fade", Range( 0 , 1)) = 0
		_Speed("Speed", Range( -5 , 5)) = 0.92
		_ShadowsSpeed("ShadowsSpeed", Range( -5 , 5)) = 0.92
		_VolumetricFill("VolumetricFill", Range( -1 , 2)) = 0

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
		Cull Off
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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

			uniform float _VolumetricFill;
			uniform sampler2D _Texture0;
			uniform float _Speed;
			uniform float4 _Texture0_ST;
			uniform half4 _Color0;
			uniform float _Fade;
			uniform half4 _Add;
			uniform float _UVClampTop;
			uniform float _Fill;
			uniform sampler2D _ShadowTex;
			uniform float _ShadowsSpeed;
			uniform float4 _ShadowTex_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord1.xy;
				
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
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV511 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode511 = ( 0.0 + 9.42 * pow( 1.0 - fresnelNdotV511, 3.45 ) );
				float temp_output_292_0 = ( 0.25 * _Speed );
				float mulTime316 = _Time.y * temp_output_292_0;
				float temp_output_315_0 = ( mulTime316 * temp_output_292_0 );
				float2 uv2_Texture0 = i.ase_texcoord2.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float2 panner150 = ( temp_output_315_0 * float2( 0,0.5 ) + uv2_Texture0);
				float temp_output_302_0 = ( 0.99 * tex2D( _Texture0, panner150 ).r );
				float MasterFade341 = _Fade;
				float2 temp_cast_0 = (0.0).xx;
				float2 texCoord200 = i.ase_texcoord2.xy * float2( 1,1 ) + temp_cast_0;
				float temp_output_255_0 = ( texCoord200.y + ( texCoord200.y * 0.02 ) );
				float smoothstepResult327 = smoothstep( -0.14 , 2.0 , ( temp_output_255_0 * ( 1.0 - temp_output_255_0 ) ));
				float Tex165 = temp_output_302_0;
				float temp_output_202_0 = ( (( _UVClampTop )?( smoothstepResult327 ):( temp_output_255_0 )) * ( (( _UVClampTop )?( smoothstepResult327 ):( temp_output_255_0 )) + ( ( MasterFade341 + -0.5 ) * ( 1.09 * Tex165 * ( 1.09 + 0.5 ) ) ) ) );
				float2 panner332 = ( temp_output_315_0 * float2( -0.1,0.7 ) + uv2_Texture0);
				float4 clampResult334 = clamp( ( ( temp_output_302_0 * _Color0 * MasterFade341 ) + ( _Add * temp_output_202_0 * MasterFade341 ) + ( ( ( 1.0 - tex2D( _Texture0, panner332 ).r ) * ( _Fill * ( MasterFade341 + -0.5 ) ) ) * _Add * MasterFade341 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
				float temp_output_588_0 = ( 0.33 * _ShadowsSpeed );
				float mulTime589 = _Time.y * temp_output_588_0;
				float2 texCoord585 = i.ase_texcoord2.xy * _ShadowTex_ST.xy + _ShadowTex_ST.zw;
				float2 panner584 = ( ( mulTime589 * temp_output_588_0 ) * float2( 0,0.2 ) + texCoord585);
				float temp_output_575_0 = ( _ShadowsSpeed * 0.25 );
				float mulTime576 = _Time.y * temp_output_575_0;
				float2 texCoord579 = i.ase_texcoord2.xy * _ShadowTex_ST.xy + _ShadowTex_ST.zw;
				float2 panner580 = ( ( mulTime576 * temp_output_575_0 ) * float2( 0,-0.3 ) + texCoord579);
				float smoothstepResult582 = smoothstep( 0.56 , 1.0 , tex2D( _ShadowTex, panner580 ).r);
				
				
				finalColor = saturate( ( ( _VolumetricFill * ( 1.0 - saturate( fresnelNode511 ) ) ) + ( clampResult334 * ( ( clampResult334.a * ( saturate( temp_output_202_0 ) * 8.0 ) ) * ( 1.0 - ( tex2D( _ShadowTex, panner584 ).r * smoothstepResult582 ) ) ) ) ) );
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
Node;AmplifyShaderEditor.RangedFloatNode;277;-2843.995,1308.176;Inherit;False;Constant;_UVfadeoffset;UV fade offset;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;-2309.711,1558.837;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;-2042.885,1312.743;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-1596.867,1831.011;Inherit;False;Constant;_TopGradient;TopGradient;2;0;Create;True;0;0;0;False;0;False;1.09;1.09;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;323;-1831.174,1589.743;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;350;-1286.169,2194.695;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;-1067.848,1939.384;Inherit;False;165;Tex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;-1051.545,2247.745;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;342;-1087.697,1623.454;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;-1623.396,1415.59;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;339;-884.639,1672.807;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-822.1516,1831.134;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;338;-715.0396,1684.008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;324;-1087.94,1321.266;Inherit;False;Property;_UVClampTop;UVClampTop;4;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-538.9608,1471.025;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-191.8068,1342.73;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;1023.739,656.0046;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;334;1210.702,473.3382;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;791.4709,1400.095;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;47;1581.687,690.1762;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;1958.618,894.626;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;200;-2560.74,1262.259;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,-0.17;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;336;-2767.328,1087.992;Inherit;False;Property;_Fade;Fade;9;0;Create;True;0;0;0;False;0;False;0;0.756;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;341;-2414.721,1081.65;Inherit;False;MasterFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-651.9298,-83.90579;Inherit;False;Constant;_TexMult;TexMult;8;0;Create;True;0;0;0;False;0;False;0.99;0.99;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;-277.9298,-29.90576;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;-1586.672,843.4905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;348;-196.6394,842.4081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;295;-549.3752,561.6177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;146;-307.3176,194.0636;Half;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0.3301923,1,0;0.09834404,0.1463442,0.2452824,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;262.8665,563.8137;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;343;-55.83913,418.4079;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;156.7561,165.2664;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;123.8917,-24.0688;Inherit;False;Tex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;2766.496,698.5756;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;546;2974.679,475.7527;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-404.8231,715.3137;Inherit;False;Property;_Fill;Fill;6;0;Create;True;0;0;0;False;0;False;1.195647;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;327;-1380.527,1564.236;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.14;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;489;-1384.041,-2347.459;Inherit;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;495;-1394.281,-2792.199;Inherit;True;Property;_TextureSample3;Texture Sample 3;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;499;817.7004,-2405.82;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;501;1128.558,-2291.569;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;502;1201.738,-1839.37;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;503;1731.57,-1995.723;Inherit;True;2;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;484;-2997.903,-2273.517;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;551;-2828.417,-2174.168;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;553;-2784.531,-2563.657;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;491;-1376.391,-1879.278;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;483;-2990.576,-1758.901;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;560;-2697.945,-1698.278;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;552;-2827.106,-1887.955;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;480;-3300.243,-1626.442;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;479;-3320.826,-2103.155;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;561;-3236.766,-1008.683;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;562;-1404.687,-1326.726;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;-3018.871,-1206.349;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;568;-2855.401,-1335.403;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;504;991.8396,-1536.939;Inherit;False;Property;_Crack;Crack;5;1;[HDR];Create;True;0;0;0;False;0;False;0.1067042,1,0,0;0.4716981,0.3017897,0.238074,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;500;470.2347,-2010.017;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;570;495.3757,-1443.43;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;497;69.50671,-2570.437;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;496;64.96283,-2101.596;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;498;73.01184,-1650.726;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;563;-183.0871,-1107.835;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;490;-2999.533,-2675.296;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;478;-3587.975,-2426.758;Inherit;False;2;2;0;FLOAT;-0.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;558;-2656.345,-2527.677;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;559;-2691.806,-2079.177;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;565;-2726.241,-1142.188;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;494;-2585.406,-2772.089;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;7,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;485;-2579.009,-2330.679;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;7,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;488;-2520.061,-1847.309;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;7,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;567;-2540.67,-1298.776;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;7,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;486;-2111.153,-2025.639;Inherit;True;Property;_CrackDepth;CrackDepth;3;0;Create;True;0;0;0;False;0;False;None;7cf6afe4105669349bd222f33ba5795d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;477;-4099.202,-1676.864;Inherit;False;Property;_Offset;Offset;1;0;Create;True;0;0;0;False;0;False;-0.001;-0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;487;-3302.8,-2389.346;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;554;-2362.128,-2628.112;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;0.03;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;555;-2323.73,-2253.714;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;566;-2293.052,-1230.76;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;0.09;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;556;-2266.107,-1783.312;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT;0.07;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;572;2709.991,-249.517;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;573;2312.552,-336.0376;Inherit;False;Property;_VolumetricFill;VolumetricFill;13;0;Create;True;0;0;0;False;0;False;0;-0.01;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;513;2206.521,-118.6299;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;511;1873.068,-252.3275;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;9.42;False;3;FLOAT;3.45;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;351;3265.312,466.1837;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;346;328.1603,1328.808;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;569.809,1142.884;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;214;491.0801,1485.855;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;-11.03946,682.4079;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;345;358.5601,919.2081;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;182;-148.5562,964.879;Half;False;Property;_Add;Add;2;0;Create;True;0;0;0;False;0;False;0.2615309,0.1718138,0.3679245,0;0.330188,0.2572317,0.1915711,0.3254902;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;585.5907,702.8898;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;512;2415.91,-187.7236;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;-467.2394,818.6078;Inherit;False;341;MasterFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;311;3580.945,464.3938;Float;False;True;-1;2;ASEMaterialInspector;100;5;Cortopia/VFX/ase_vfx_lightshaft;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;331;-1527.595,695.612;Inherit;False;1;329;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;332;-1290.859,844.414;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0.7;False;1;FLOAT;0.25;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;330;-881.2869,850.1581;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;329;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;329;-1125.79,530.3973;Inherit;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;0;False;0;False;None;21b46c6e6bfb16e4abfced00ad9152cd;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;150;-1292.631,284.9671;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;0.25;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;105;-1511.804,167.9097;Inherit;False;1;329;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-842.9127,248.3297;Inherit;True;Property;_Beams;Beams;0;0;Create;True;0;0;0;False;0;False;329;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;290;-2479.886,327.5048;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2261.605,394.9175;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;316;-1998.116,341.6867;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;-1746.159,371.3853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-2758.991,414.7987;Inherit;False;Property;_Speed;Speed;10;0;Create;True;0;0;0;False;0;False;0.92;0.39;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;575;-782.5382,3214.288;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;576;-519.0492,3161.057;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;577;-267.0923,3190.756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;586;643.4977,2677.214;Inherit;True;Property;_Beams1;Beams;0;0;Create;True;0;0;0;False;0;False;329;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;588;-780.5023,2821.214;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;589;-508.5023,2773.214;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;590;-252.5023,2789.214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;581;625.5544,3584.917;Inherit;True;Property;_MovementShadow;MovementShadow;0;0;Create;True;0;0;0;False;0;False;329;None;02b22951e9478c246b3ef1b018bd8ec6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;583;286.4977,3047.214;Inherit;True;Property;_ShadowTex;ShadowTex;8;0;Create;True;0;0;0;False;0;False;None;02b22951e9478c246b3ef1b018bd8ec6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;591;-1276.502,2837.214;Inherit;False;Property;_Speed1;;12;0;Create;True;0;0;0;False;0;False;0.92;0.39;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;587;-988.5023,2757.214;Inherit;False;Constant;_Float4;Float 2;9;0;Create;True;0;0;0;False;0;False;0.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;578;-1316.324,3059.969;Inherit;False;Property;_ShadowsSpeed;ShadowsSpeed;11;0;Create;True;0;0;0;False;0;False;0.92;1.98;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;574;-1012.519,3319.776;Inherit;False;Constant;_Float3;Float 2;9;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;579;-204.8121,3651.933;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;592;1473.48,2920.155;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;594;-617.4973,2586.593;Inherit;False;583;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;595;2518.465,1401.727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;596;1886.374,2874.876;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;585;-28.50229,2597.214;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;582;1066.586,3372.516;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.56;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;584;195.4978,2709.214;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.2;False;1;FLOAT;0.25;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;580;188.2079,3663.785;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.3;False;1;FLOAT;0.25;False;1;FLOAT2;0
WireConnection;254;0;200;2
WireConnection;255;0;200;2
WireConnection;255;1;254;0
WireConnection;323;0;255;0
WireConnection;350;0;204;0
WireConnection;261;0;350;0
WireConnection;326;0;255;0
WireConnection;326;1;323;0
WireConnection;339;0;342;0
WireConnection;262;0;204;0
WireConnection;262;1;259;0
WireConnection;262;2;261;0
WireConnection;338;0;339;0
WireConnection;338;1;262;0
WireConnection;324;0;255;0
WireConnection;324;1;327;0
WireConnection;279;0;324;0
WireConnection;279;1;338;0
WireConnection;202;0;324;0
WireConnection;202;1;279;0
WireConnection;183;0;147;0
WireConnection;183;1;189;0
WireConnection;183;2;298;0
WireConnection;334;0;183;0
WireConnection;352;0;214;0
WireConnection;47;0;334;0
WireConnection;211;0;47;3
WireConnection;211;1;352;0
WireConnection;200;1;277;0
WireConnection;341;0;336;0
WireConnection;302;0;303;0
WireConnection;302;1;6;1
WireConnection;349;0;315;0
WireConnection;348;0;344;0
WireConnection;295;0;330;1
WireConnection;296;0;295;0
WireConnection;296;1;347;0
WireConnection;147;0;302;0
WireConnection;147;1;146;0
WireConnection;147;2;343;0
WireConnection;165;0;302;0
WireConnection;197;0;334;0
WireConnection;197;1;595;0
WireConnection;546;0;572;0
WireConnection;546;1;197;0
WireConnection;327;0;326;0
WireConnection;489;0;486;0
WireConnection;489;1;555;0
WireConnection;495;0;486;0
WireConnection;495;1;554;0
WireConnection;499;0;497;0
WireConnection;499;1;500;0
WireConnection;499;2;570;0
WireConnection;501;0;499;0
WireConnection;502;0;501;0
WireConnection;502;1;504;0
WireConnection;503;1;502;0
WireConnection;484;0;487;0
WireConnection;484;1;479;0
WireConnection;551;0;484;0
WireConnection;553;0;490;0
WireConnection;491;0;486;0
WireConnection;491;1;556;0
WireConnection;483;0;487;0
WireConnection;483;1;480;0
WireConnection;560;0;552;0
WireConnection;560;1;552;1
WireConnection;552;0;483;0
WireConnection;480;0;479;0
WireConnection;480;1;477;0
WireConnection;479;0;478;0
WireConnection;479;1;477;0
WireConnection;561;0;480;0
WireConnection;561;1;477;0
WireConnection;562;0;486;0
WireConnection;562;1;566;0
WireConnection;564;0;487;0
WireConnection;564;1;561;0
WireConnection;568;0;564;0
WireConnection;500;0;496;0
WireConnection;500;1;498;0
WireConnection;570;0;498;0
WireConnection;570;1;563;0
WireConnection;497;0;495;1
WireConnection;496;0;489;1
WireConnection;498;0;491;1
WireConnection;563;0;562;1
WireConnection;490;0;487;0
WireConnection;490;1;478;0
WireConnection;478;1;477;0
WireConnection;558;0;553;0
WireConnection;558;1;553;1
WireConnection;559;0;551;0
WireConnection;559;1;551;1
WireConnection;565;0;568;0
WireConnection;494;1;558;0
WireConnection;485;1;559;0
WireConnection;488;1;560;0
WireConnection;567;1;565;0
WireConnection;554;0;494;0
WireConnection;555;0;485;0
WireConnection;566;0;567;0
WireConnection;556;0;488;0
WireConnection;572;0;573;0
WireConnection;572;1;512;0
WireConnection;513;0;511;0
WireConnection;351;0;546;0
WireConnection;189;0;182;0
WireConnection;189;1;202;0
WireConnection;189;2;346;0
WireConnection;214;0;202;0
WireConnection;347;0;297;0
WireConnection;347;1;348;0
WireConnection;298;0;296;0
WireConnection;298;1;182;0
WireConnection;298;2;345;0
WireConnection;512;0;513;0
WireConnection;311;0;351;0
WireConnection;332;0;331;0
WireConnection;332;1;349;0
WireConnection;330;0;329;0
WireConnection;330;1;332;0
WireConnection;150;0;105;0
WireConnection;150;1;315;0
WireConnection;6;0;329;0
WireConnection;6;1;150;0
WireConnection;292;0;290;0
WireConnection;292;1;291;0
WireConnection;316;0;292;0
WireConnection;315;0;316;0
WireConnection;315;1;292;0
WireConnection;575;0;578;0
WireConnection;575;1;574;0
WireConnection;576;0;575;0
WireConnection;577;0;576;0
WireConnection;577;1;575;0
WireConnection;586;0;583;0
WireConnection;586;1;584;0
WireConnection;588;0;587;0
WireConnection;588;1;578;0
WireConnection;589;0;588;0
WireConnection;590;0;589;0
WireConnection;590;1;588;0
WireConnection;581;0;583;0
WireConnection;581;1;580;0
WireConnection;579;0;594;0
WireConnection;579;1;594;1
WireConnection;592;0;586;1
WireConnection;592;1;582;0
WireConnection;595;0;211;0
WireConnection;595;1;596;0
WireConnection;596;0;592;0
WireConnection;585;0;594;0
WireConnection;585;1;594;1
WireConnection;582;0;581;1
WireConnection;584;0;585;0
WireConnection;584;1;590;0
WireConnection;580;0;579;0
WireConnection;580;1;577;0
ASEEND*/
//CHKSM=B4FA7E829ECADF0D29D35A4BBDACCB306279F83B