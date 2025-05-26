// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_parallax_offset_crack"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Surface("Surface", 2D) = "white" {}
		_Offset("Offset", Float) = -0.001
		_CrackDepth("CrackDepth", 2D) = "white" {}
		_Boost("Boost", Range( 0 , 10)) = 1
		[HDR]_Crack("Crack", Color) = (0.1067042,1,0,0)
		[Toggle]_InvertMask("InvertMask", Float) = 0
		_FadeIn("FadeIn", Range( 0 , 1.5)) = 0
		_HotspotScale("HotspotScale", Range( 0 , 1)) = 5
		[HDR]_Hotspot("Hotspot", Color) = (1,0.9719429,0.7216981,0)

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Back
			Lighting Off 
			ZWrite On
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
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					half4 ase_tangent : TANGENT;
					half3 ase_normal : NORMAL;
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
					float4 ase_texcoord5 : TEXCOORD5;
					float4 ase_texcoord6 : TEXCOORD6;
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
				uniform half _InvertMask;
				uniform sampler2D _Surface;
				uniform half4 _Surface_ST;
				uniform half _HotspotScale;
				uniform half4 _Hotspot;
				uniform half _Boost;
				uniform sampler2D _CrackDepth;
				uniform half _Offset;
				uniform half4 _Crack;
				uniform half _FadeIn;


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					half3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
					o.ase_texcoord3.xyz = ase_worldTangent;
					half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
					o.ase_texcoord4.xyz = ase_worldNormal;
					half ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
					float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
					o.ase_texcoord5.xyz = ase_worldBitangent;
					float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					o.ase_texcoord6.xyz = ase_worldPos;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord3.w = 0;
					o.ase_texcoord4.w = 0;
					o.ase_texcoord5.w = 0;
					o.ase_texcoord6.w = 0;

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
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

					half2 texCoord223 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					half4 tex2DNode220 = tex2D( _Surface, texCoord223 );
					half4 temp_cast_0 = ((( _InvertMask )?( ( 1.0 - tex2DNode220.r ) ):( saturate( tex2DNode220.r ) ))).xxxx;
					half2 uv_Surface = i.texcoord.xy * _Surface_ST.xy + _Surface_ST.zw;
					half2 CenteredUV15_g2 = ( uv_Surface - float2( 0.5,0.5 ) );
					half2 break17_g2 = CenteredUV15_g2;
					half2 appendResult23_g2 = (half2(( length( CenteredUV15_g2 ) * 3.11 * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * 0.29 )));
					half saferPower365 = max( ( 1.0 - ( appendResult23_g2.x * ( 1.0 - _HotspotScale ) ) ) , 0.0001 );
					half temp_output_365_0 = pow( saferPower365 , 8.95 );
					half3 ase_worldTangent = i.ase_texcoord3.xyz;
					half3 ase_worldNormal = i.ase_texcoord4.xyz;
					float3 ase_worldBitangent = i.ase_texcoord5.xyz;
					half3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
					half3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
					half3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
					float3 ase_worldPos = i.ase_texcoord6.xyz;
					float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
					ase_worldViewDir = normalize(ase_worldViewDir);
					half3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
					ase_tanViewDir = normalize(ase_tanViewDir);
					half temp_output_227_0 = ( 0.01 + _Offset );
					half2 texCoord211 = i.texcoord.xy * float2( 1,1 ) + ( ase_tanViewDir * temp_output_227_0 ).xy;
					half lerpResult228 = lerp( tex2D( _CrackDepth, texCoord211 ).r , 1.0 , 0.1);
					half temp_output_233_0 = ( temp_output_227_0 + _Offset );
					half2 texCoord230 = i.texcoord.xy * float2( 1,1 ) + ( ase_tanViewDir * temp_output_233_0 ).xy;
					half smoothstepResult274 = smoothstep( 0.05 , 1.0 , tex2D( _CrackDepth, texCoord230 ).r);
					half lerpResult234 = lerp( smoothstepResult274 , 1.0 , 0.2);
					half2 texCoord236 = i.texcoord.xy * float2( 1,1 ) + ( ase_tanViewDir * ( temp_output_233_0 + _Offset ) ).xy;
					half smoothstepResult275 = smoothstep( 0.15 , 1.0 , tex2D( _CrackDepth, texCoord236 ).r);
					half lerpResult240 = lerp( smoothstepResult275 , 1.0 , 0.3);
					half4 blendOpSrc222 = temp_cast_0;
					half4 blendOpDest222 = saturate( ( ( saturate( ( temp_output_365_0 * 2.0 ) ) * _Hotspot * _HotspotScale ) + saturate( ( _Boost * ( saturate( ( lerpResult228 * ( lerpResult234 * lerpResult240 ) ) ) * _Crack ) ) ) ) );
					half4 break339 = (( blendOpDest222 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest222 ) * ( 1.0 - blendOpSrc222 ) ) : ( 2.0 * blendOpDest222 * blendOpSrc222 ) );
					half4 appendResult356 = (half4(break339.r , break339.g , break339.b , 0.0));
					half4 break355 = appendResult356;
					half smoothstepResult347 = smoothstep( ( 1.0 - _FadeIn ) , 1.0 , i.color.r);
					half4 appendResult340 = (half4(break355.x , break355.y , break355.z , ( ( break339.a * smoothstepResult347 ) * 2.0 )));
					

					fixed4 col = saturate( appendResult340 );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
2560;0;2560;1379;-3146.076;1733.895;1.229694;True;True
Node;AmplifyShaderEditor.RangedFloatNode;218;-1076.452,-313.8395;Inherit;False;Property;_Offset;Offset;1;0;Create;True;0;0;0;False;0;False;-0.001;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;227;-595.014,-315.6698;Inherit;False;2;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;233;-465.539,20.14613;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;239;-377.3336,564.4805;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;232;-236.2272,-241.384;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;238;-227.142,264.1057;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;35.30531,335.2715;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;30.52455,-132.9081;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;189.9586,-176.234;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;325;802.7147,-394.2646;Inherit;True;Property;_CrackDepth;CrackDepth;2;0;Create;True;0;0;0;False;0;False;None;0d68c70236c0022489b7c791a59f19b5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;219;-257.9476,-699.0397;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;236;200.4785,293.3809;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;229;1447.096,-221.7426;Inherit;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;e1782fb24b573ea4c865b6aea8ff7189;e1782fb24b573ea4c865b6aea8ff7189;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;358;3356.206,-1500.992;Inherit;True;0;220;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;21.71962,-591.9989;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;235;1454.746,246.4372;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;e1782fb24b573ea4c865b6aea8ff7189;e1782fb24b573ea4c865b6aea8ff7189;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;366;3308.032,-1085.556;Inherit;False;Property;_HotspotScale;HotspotScale;7;0;Create;True;0;0;0;False;0;False;5;0.74;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;360;3629.51,-1452.892;Inherit;True;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;3.11;False;4;FLOAT;0.29;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;274;2106.477,-27.60073;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;275;2030.228,407.2509;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;211;179.7186,-638.1948;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;370;3631.376,-1034.407;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;361;3925.946,-1499.33;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;234;2896.101,24.12016;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;240;2900.95,474.9899;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;210;1436.856,-666.4834;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;e1782fb24b573ea4c865b6aea8ff7189;e1782fb24b573ea4c865b6aea8ff7189;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;3438.973,90.0983;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;228;2900.645,-444.7208;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;362;4053.571,-1392.26;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;3712.091,-232.6654;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;364;4291.343,-1283.829;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;365;4442.354,-1477.552;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;8.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;280;3771.03,591.4144;Inherit;False;Property;_Crack;Crack;4;1;[HDR];Create;True;0;0;0;False;0;False;0.1067042,1,0,0;0.06666667,0,0.1333333,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;334;4022.949,-118.414;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;4048.759,60.07583;Inherit;False;Property;_Boost;Boost;3;0;Create;True;0;0;0;False;0;False;1;9.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;4704.099,-1148.56;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;4096.128,333.7848;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;354;4357.896,-881.8778;Inherit;False;Property;_Hotspot;Hotspot;8;1;[HDR];Create;True;0;0;0;False;0;False;1,0.9719429,0.7216981,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;369;4839.816,-1144.743;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;223;4294.577,810.1615;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;4378.637,199.1039;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;220;4548.579,607.9908;Inherit;True;Property;_Surface;Surface;0;0;Create;True;0;0;0;False;0;False;-1;6cf93571331c7c94d8f86a63128d2977;0d68c70236c0022489b7c791a59f19b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;4807.399,-939.2471;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;318;4838.342,-323.0917;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;333;4926.53,440.0887;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;353;5063.889,-634.0327;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;317;4726.272,174.88;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;5230.836,568.9168;Inherit;False;Property;_FadeIn;FadeIn;6;0;Create;True;0;0;0;False;0;False;0;1.5;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;371;5312.966,-624.849;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;331;4903.059,188.8122;Inherit;False;Property;_InvertMask;InvertMask;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;336;5208.159,58.61693;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;349;5524.058,306.4768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;222;5265.461,-249.6176;Inherit;True;Overlay;False;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;339;5692.539,-307.5034;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SmoothstepOpNode;347;5737.902,251.3967;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;356;5940.349,-347.703;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;6016.542,-49.9234;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;6259.219,92.63654;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;355;6269.712,-369.9415;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;340;6487.959,-163.9434;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;368;6887.423,-271.5355;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;373;4839.752,-1518.406;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;4299.146,-246.8803;Inherit;False;Boost;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;7258.34,-46.2372;Half;False;True;-1;2;ASEMaterialInspector;0;7;Cortopia/VFX/ase_vfx_parallax_offset_crack;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;True;0;False;-1;False;True;True;True;True;False;0;False;-1;False;False;False;False;False;False;False;False;True;True;0;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;227;1;218;0
WireConnection;233;0;227;0
WireConnection;233;1;218;0
WireConnection;239;0;233;0
WireConnection;239;1;218;0
WireConnection;237;0;238;0
WireConnection;237;1;239;0
WireConnection;231;0;232;0
WireConnection;231;1;233;0
WireConnection;230;1;231;0
WireConnection;236;1;237;0
WireConnection;229;0;325;0
WireConnection;229;1;230;0
WireConnection;217;0;219;0
WireConnection;217;1;227;0
WireConnection;235;0;325;0
WireConnection;235;1;236;0
WireConnection;360;1;358;0
WireConnection;274;0;229;1
WireConnection;275;0;235;1
WireConnection;211;1;217;0
WireConnection;370;0;366;0
WireConnection;361;0;360;0
WireConnection;234;0;274;0
WireConnection;240;0;275;0
WireConnection;210;0;325;0
WireConnection;210;1;211;0
WireConnection;258;0;234;0
WireConnection;258;1;240;0
WireConnection;228;0;210;1
WireConnection;362;0;361;0
WireConnection;362;1;370;0
WireConnection;259;0;228;0
WireConnection;259;1;258;0
WireConnection;364;0;362;0
WireConnection;365;0;364;0
WireConnection;334;0;259;0
WireConnection;374;0;365;0
WireConnection;281;0;334;0
WireConnection;281;1;280;0
WireConnection;369;0;374;0
WireConnection;314;0;315;0
WireConnection;314;1;281;0
WireConnection;220;1;223;0
WireConnection;357;0;369;0
WireConnection;357;1;354;0
WireConnection;357;2;366;0
WireConnection;318;0;314;0
WireConnection;333;0;220;1
WireConnection;353;0;357;0
WireConnection;353;1;318;0
WireConnection;317;0;220;1
WireConnection;371;0;353;0
WireConnection;331;0;317;0
WireConnection;331;1;333;0
WireConnection;349;0;338;0
WireConnection;222;0;331;0
WireConnection;222;1;371;0
WireConnection;339;0;222;0
WireConnection;347;0;336;1
WireConnection;347;1;349;0
WireConnection;356;0;339;0
WireConnection;356;1;339;1
WireConnection;356;2;339;2
WireConnection;344;0;339;3
WireConnection;344;1;347;0
WireConnection;352;0;344;0
WireConnection;355;0;356;0
WireConnection;340;0;355;0
WireConnection;340;1;355;1
WireConnection;340;2;355;2
WireConnection;340;3;352;0
WireConnection;368;0;340;0
WireConnection;373;0;365;0
WireConnection;319;0;315;0
WireConnection;0;0;368;0
ASEEND*/
//CHKSM=54322BFBBECF3A26C55C7469C12CAB64EE5C1FA6