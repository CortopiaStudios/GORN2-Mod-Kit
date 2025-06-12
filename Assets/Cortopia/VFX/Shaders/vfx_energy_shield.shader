// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_energy_shield"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Scroll("Scroll", Range( 0 , 0.79)) = 0.560603
		_Shaper("Shaper", Range( 0 , 15)) = 0.68
		_Bulge("Bulge", Float) = 0
		_Noise("Noise", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (1,1,1,0)
		[HDR]_ColorAdd("ColorAdd", Color) = (1,1,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_ScrollSpeed("ScrollSpeed", Range( -5 , 5)) = 0
		_NoiseMult("NoiseMult", Range( 0 , 2)) = 1
		_NoiseTexAffect("NoiseTexAffect", Range( 0 , 1)) = 1

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend One OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					float3 ase_normal : NORMAL;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform sampler2D _Noise;
				uniform float _ScrollSpeed;
				uniform float4 _Noise_ST;
				uniform float _Shaper;
				uniform float _Bulge;
				uniform float4 _Color0;
				uniform float _Scroll;
				uniform sampler2D _TextureSample0;
				uniform float _NoiseMult;
				uniform float _NoiseTexAffect;
				uniform float4 _ColorAdd;


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					float2 appendResult699 = (float2(0.1 , 0.2));
					float2 texCoord616 = v.texcoord.xy * _Noise_ST.xy + _Noise_ST.zw;
					float2 panner664 = ( -1.0 * _Time.y * ( appendResult699 * _ScrollSpeed ) + texCoord616);
					float4 tex2DNode614 = tex2Dlod( _Noise, float4( panner664, 0, 0.0) );
					float clampResult708 = clamp( tex2DNode614.r , 0.2 , 0.8 );
					
					float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
					o.ase_texcoord3.xyz = ase_worldPos;
					float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
					o.ase_texcoord4.xyz = ase_worldNormal;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord3.w = 0;
					o.ase_texcoord4.w = 0;

					v.vertex.xyz += ( ( (-1.0 + (( clampResult708 * _Shaper ) - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * v.ase_normal ) * _Bulge );
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float4 appendResult209 = (float4(0.0 , ( 1.0 - _Scroll ) , 0.0 , 0.0));
					float2 texCoord212 = i.texcoord.xy * float2( 1.3,0.46 ) + appendResult209.xy;
					float smoothstepResult222 = smoothstep( 0.1 , 0.11 , ( texCoord212.y * ( 1.0 - texCoord212.y ) ));
					float clampResult330 = clamp( smoothstepResult222 , 0.0 , 1.0 );
					float MaskScroll603 = clampResult330;
					float3 ase_worldPos = i.ase_texcoord3.xyz;
					float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
					ase_worldViewDir = normalize(ase_worldViewDir);
					float3 ase_worldNormal = i.ase_texcoord4.xyz;
					float fresnelNdotV620 = dot( ase_worldNormal, ase_worldViewDir );
					float fresnelNode620 = ( 0.0 + 2.36 * pow( 1.0 - fresnelNdotV620, 2.58 ) );
					float4 break622 = ( _Color0 * MaskScroll603 * ( 1.0 - ( fresnelNode620 * 0.19 ) ) );
					float4 _Noise_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Noise_ST_arr, _Noise_ST);
					float2 texCoord629 = i.texcoord.xy * _Noise_ST_Instance.xy + _Noise_ST_Instance.zw;
					float4 tex2DNode625 = tex2D( _TextureSample0, texCoord629 );
					float2 appendResult699 = (float2(0.1 , 0.2));
					float2 texCoord616 = i.texcoord.xy * _Noise_ST.xy + _Noise_ST.zw;
					float2 panner664 = ( -1.0 * _Time.y * ( appendResult699 * _ScrollSpeed ) + texCoord616);
					float4 tex2DNode614 = tex2D( _Noise, panner664 );
					float lerpResult712 = lerp( tex2DNode625.r , ( tex2DNode625.r * ( _NoiseMult * tex2DNode614.r ) ) , _NoiseTexAffect);
					float temp_output_680_0 = ( break622.a * lerpResult712 * i.color.a * tex2DNode614.r );
					float4 appendResult623 = (float4(break622.r , break622.g , break622.b , temp_output_680_0));
					float4 clampResult692 = clamp( ( appendResult623 + ( tex2DNode614.r * _ColorAdd * fresnelNode620 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
					

					fixed4 col = saturate( ( clampResult692 * temp_output_680_0 ) );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.RangedFloatNode;205;-1015.975,2339.871;Inherit;False;Property;_Scroll;Scroll;0;0;Create;True;0;0;0;False;0;False;0.560603;0.79;0;0.79;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;207;-716.0192,2369.125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;213;-56.02032,2655.828;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;628;777.7582,258.731;Inherit;False;614;True;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;629;1028.021,260.3361;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;603;928.3094,2691.94;Inherit;False;MaskScroll;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;611;1993.296,-330.5656;Inherit;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0.3199668,0.3841174,1.739306,0.945098;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;2240.749,-136.6754;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-1161.202,23.81073;Inherit;False;Property;_erode;erode;1;0;Create;True;0;0;0;False;0;False;0.3514822;0;-1;0.79;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;450;-815.2171,-139.5376;Inherit;False;Erode;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;383;-712.6346,55.22343;Inherit;False;Property;_Boost;Boost;2;0;Create;True;0;0;0;False;0;False;5;100;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;686;3830.72,530.8704;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;624;3378.889,391.7565;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;688;2664.539,688.8119;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;692;3343.624,38.24542;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;623;2934.982,-29.76069;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;622;2470.993,-208.9356;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;209;-527.3171,2394.426;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;700;-8.491486,1790.764;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;701;-3.491486,1872.764;Inherit;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;212;-306.2143,2497.226;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.3,0.46;False;1;FLOAT2;0,-0.06;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;698;-318.7708,1272.336;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;9;0;Create;True;0;0;0;False;0;False;0;0.17;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;699;132.4286,1790.764;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;132.6827,2564.827;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;616;538.2781,1358.919;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;702;356.167,1655.686;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;664;762.8724,1678.917;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;222;366.8824,2556.525;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;330;612.5214,2560.874;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;580;1182.276,1866.557;Inherit;False;Property;_Shaper;Shaper;3;0;Create;True;0;0;0;False;0;False;0.68;6.47;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;619;1510.964,1560.627;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;676;1722.84,1545.997;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;675;2019.052,1569.631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;639;2514.725,1743.133;Inherit;False;Property;_Bulge;Bulge;4;0;Create;True;0;0;0;False;0;False;0;-1.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;643;2993.899,1436.398;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;635;1298.165,2111.479;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;707;2061.569,175.3499;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;609;1758.628,-175.8055;Inherit;False;603;MaskScroll;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;620;1218.65,-120.3059;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2.36;False;3;FLOAT;2.58;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;684;3105.113,97.313;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;687;2280.38,1038.697;Inherit;False;Property;_ColorAdd;ColorAdd;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0.04486636,1.496439,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;703;1895.563,696.4491;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;706;1213.101,709.75;Inherit;False;Property;_NoiseMult;NoiseMult;10;0;Create;True;0;0;0;False;0;False;1;0.64;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;712;2122.24,641.2264;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;713;1793.341,814.1266;Inherit;False;Property;_NoiseTexAffect;NoiseTexAffect;11;0;Create;True;0;0;0;False;0;False;1;0.997;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;705;1657.074,706.9625;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;680;2642.375,403.0699;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;710;1564.094,-176.0301;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;709;1895.193,7.598275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;625;1547.302,370.9772;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;a9f4291b07f5aca4a89142e6a37dfe25;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;150;4094.615,656.7384;Float;False;True;-1;2;ASEMaterialInspector;0;11;vfx_energy_shield;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;True;3;1;False;;10;False;;0;5;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;True;True;2;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;False;True;True;2;False;;True;3;False;;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SamplerNode;614;1059.508,1335.389;Inherit;True;Property;_Noise;Noise;5;0;Create;True;0;0;0;False;0;False;-1;None;21b46c6e6bfb16e4abfced00ad9152cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;617;299.3282,1385.453;Inherit;False;614;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.ClampOpNode;708;1344.296,1420.436;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
WireConnection;207;0;205;0
WireConnection;213;0;212;2
WireConnection;629;0;628;0
WireConnection;629;1;628;1
WireConnection;603;0;330;0
WireConnection;610;0;611;0
WireConnection;610;1;609;0
WireConnection;610;2;709;0
WireConnection;450;0;224;0
WireConnection;686;0;624;0
WireConnection;624;0;692;0
WireConnection;624;1;680;0
WireConnection;688;0;614;1
WireConnection;688;1;687;0
WireConnection;688;2;620;0
WireConnection;692;0;684;0
WireConnection;623;0;622;0
WireConnection;623;1;622;1
WireConnection;623;2;622;2
WireConnection;623;3;680;0
WireConnection;622;0;610;0
WireConnection;209;1;207;0
WireConnection;212;1;209;0
WireConnection;699;0;700;0
WireConnection;699;1;701;0
WireConnection;216;0;212;2
WireConnection;216;1;213;0
WireConnection;616;0;617;0
WireConnection;616;1;617;1
WireConnection;702;0;699;0
WireConnection;702;1;698;0
WireConnection;664;0;616;0
WireConnection;664;2;702;0
WireConnection;222;0;216;0
WireConnection;330;0;222;0
WireConnection;619;0;708;0
WireConnection;619;1;580;0
WireConnection;676;0;619;0
WireConnection;675;0;676;0
WireConnection;675;1;635;0
WireConnection;643;0;675;0
WireConnection;643;1;639;0
WireConnection;684;0;623;0
WireConnection;684;1;688;0
WireConnection;703;0;625;1
WireConnection;703;1;705;0
WireConnection;712;0;625;1
WireConnection;712;1;703;0
WireConnection;712;2;713;0
WireConnection;705;0;706;0
WireConnection;705;1;614;1
WireConnection;680;0;622;3
WireConnection;680;1;712;0
WireConnection;680;2;707;4
WireConnection;680;3;614;1
WireConnection;710;0;620;0
WireConnection;709;0;710;0
WireConnection;625;1;629;0
WireConnection;150;0;686;0
WireConnection;150;1;643;0
WireConnection;614;1;664;0
WireConnection;708;0;614;1
ASEEND*/
//CHKSM=D6D13A02B15AEF6DACD0F7DDF8AE3C467AFA64E7