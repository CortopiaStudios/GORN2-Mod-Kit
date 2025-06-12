// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_powerup_outline_fresnel"
{
	Properties
	{
		_Fade("Fade", Range( 0 , 1)) = 2.67783
		_TexBoost("TexBoost", Range( 0 , 5)) = 2.67783
		_ColorBase("ColorBase", Color) = (0,0.07380676,0.5283019,1)
		_Shaper("Shaper", Range( 0 , 1)) = 0.68
		_ScrollSpeed("ScrollSpeed", Range( -5 , 5)) = 0
		_ShapeTex("ShapeTex", 2D) = "white" {}
		_NoiseTile("NoiseTile", Range( -1 , 1)) = 0
		_NoiseSpeed("NoiseSpeed", Range( -5 , 5)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_Texture0("Texture 0", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha
		AlphaToMask Off
		Cull Front
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
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				half3 ase_normal : NORMAL;
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

			uniform sampler2D _ShapeTex;
			uniform half _ScrollSpeed;
			uniform half _Shaper;
			uniform sampler2D _Texture0;
			uniform half _NoiseTile;
			uniform half _NoiseSpeed;
			uniform half _TexBoost;
			uniform half _Fade;
			uniform half4 _ColorBase;
			uniform half _Opacity;
			inline float4 TriplanarSampling562( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.zy * float2(  nsign.x, 1.0 ), 0, 0) );
				yNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.xz * float2(  nsign.y, 1.0 ), 0, 0) );
				zNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.xy * float2( -nsign.z, 1.0 ), 0, 0) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			
			inline float4 TriplanarSampling589( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				half2 appendResult552 = (half2(0.1 , 0.2));
				half2 panner544 = ( -1.0 * _Time.y * ( appendResult552 * _ScrollSpeed ) + float2( 5,5 ));
				float4 triplanar562 = TriplanarSampling562( _ShapeTex, half3( panner544 ,  0.0 ), v.ase_normal, 1.0, float2( 1,1 ), 1.0, 0 );
				
				half3 normalizeWorldNormal = normalize( UnityObjectToWorldNormal(v.ase_normal) );
				o.ase_texcoord1.xyz = normalizeWorldNormal;
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( triplanar562.x * _Shaper ) * v.ase_normal );
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
				half3 normalizeWorldNormal = i.ase_texcoord1.xyz;
				half fresnelNdotV571 = dot( normalizeWorldNormal, ase_worldViewDir );
				half fresnelNode571 = ( -20.9 + 7.0 * pow( 1.0 - fresnelNdotV571, 2.23 ) );
				half temp_output_576_0 = ( 1.0 - fresnelNode571 );
				half2 temp_cast_0 = (_NoiseTile).xx;
				half3 ase_worldNormal = i.ase_texcoord2.xyz;
				half2 temp_cast_1 = (_NoiseSpeed).xx;
				half2 panner586 = ( 1.0 * _Time.y * temp_cast_1 + float2( 1,1 ));
				half2 break594 = panner586;
				half3 appendResult593 = (half3(( break594.x + WorldPosition.x ) , ( break594.y + WorldPosition.y ) , WorldPosition.z));
				float4 triplanar589 = TriplanarSampling589( _Texture0, appendResult593, ase_worldNormal, 1.0, temp_cast_0, 1.0, 0 );
				half temp_output_572_0 = ( temp_output_576_0 * triplanar589.x * _TexBoost );
				half smoothstepResult583 = smoothstep( 0.8 , 0.9 , saturate( temp_output_572_0 ));
				half4 break529 = saturate( ( ( 1.0 - smoothstepResult583 ) * saturate( ( _Fade * _ColorBase * _ColorBase.a ) ) ) );
				half4 appendResult530 = (half4(break529.r , break529.g , break529.b , ( break529.a * ( _ColorBase.a * _Opacity ) )));
				
				
				finalColor = appendResult530;
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
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-835.7007,1606.052;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;543;-1983.731,2261.282;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;547;-655.7322,2549.282;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;549;-2831.731,2181.282;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;4;0;Create;True;0;0;0;False;0;False;0;0.15;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;550;-2527.731,2693.282;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;551;-2527.731,2773.282;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;552;-2383.731,2693.282;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;553;-2159.731,2565.282;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;556;64.26768,2629.282;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;545;-975.7319,2853.282;Inherit;False;Property;_Shaper;Shaper;3;0;Create;True;0;0;0;False;0;False;0.68;0.763;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;554;-2266.477,2278.902;Inherit;False;250;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-1626.657,1469.616;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;563;-1593.229,2303.238;Inherit;True;Property;_ShapeTex;ShapeTex;5;0;Create;True;0;0;0;False;0;False;None;283ecf1283a72244383b6e9ab106f330;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;578;-1192.126,1536.597;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;265;-1429.664,1517.079;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;587;-3213.341,1455.669;Inherit;False;Property;_NoiseTile;NoiseTile;7;0;Create;True;0;0;0;False;0;False;0;0.155;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;588;-3282.292,1589.81;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;8;0;Create;True;0;0;0;False;0;False;0;-0.95;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;586;-3006.93,1586.522;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;595;-2712.271,1705.573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;585;-2752.906,1845.324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;594;-2849.849,1669.992;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;591;-3215.139,1928.542;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;540;-977.9341,1585.851;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;555;-242.1691,2815.192;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;596;-134.7712,2421.887;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;544;-1759.731,2580.282;Inherit;False;3;0;FLOAT2;5,5;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;589;-2464.056,1524.107;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;597;-1898.178,1322.362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;562;-1300.498,2657.965;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;581;-1117.118,903.1265;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;576;-2105.611,675.8309;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;582;-1718.7,1141.268;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;600;-2613.094,567.1082;Inherit;False;Standard;WorldNormal;ViewDir;True;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2.58;False;3;FLOAT;1.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;572;-2090.069,1012.115;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;602;-1588.094,738.1082;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;601;-2360.094,562.1082;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;593;-2559.072,1799.768;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;599;-1827.894,626.7083;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;577;-1450.926,856.2972;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.71;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;575;-3163.126,1262.597;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;584;-3453.7,954.2679;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;574;-3422.211,1231.983;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;580;-2928.127,1240.923;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;590;-2791.971,1124.047;Inherit;True;Property;_Texture0;Texture 0;11;0;Create;True;0;0;0;False;0;False;None;283ecf1283a72244383b6e9ab106f330;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;573;-2581.376,1048.467;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;283ecf1283a72244383b6e9ab106f330;138dff2decdf168479497897cb336dd6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;598;-2433.779,1289.263;Inherit;False;Property;_TexBoost;TexBoost;1;0;Create;True;0;0;0;False;0;False;2.67783;0.62;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;571;-2444.886,837.5822;Inherit;False;Standard;WorldNormal;ViewDir;True;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-20.9;False;2;FLOAT;7;False;3;FLOAT;2.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;741.8466,1626.183;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_powerup_outline_fresnel;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;True;True;False;0;False;;255;False;;255;False;;2;False;;3;False;;3;False;;1;False;;1;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;False;100;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638587125945191860;0;1;True;False;;False;0
Node;AmplifyShaderEditor.DynamicAppendNode;530;-570.7444,1588.26;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-723.894,1887.217;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;568;-1473.895,1868.663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;604;-1938.987,1881.386;Inherit;False;Property;_Strength;Strength;10;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-2026.312,1475.473;Inherit;False;Property;_Fade;Fade;0;0;Create;True;0;0;0;False;0;False;2.67783;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;567;-1962.807,1997.543;Inherit;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;478;-1978.052,1608.51;Inherit;False;Property;_ColorBase;ColorBase;2;0;Create;True;0;0;0;False;0;False;0,0.07380676,0.5283019,1;0.1215686,0.8980393,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;583;-1475.514,1193.268;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;0.9;False;1;FLOAT;0
WireConnection;529;0;540;0
WireConnection;543;0;554;0
WireConnection;543;1;554;1
WireConnection;547;0;562;1
WireConnection;547;1;545;0
WireConnection;552;0;550;0
WireConnection;552;1;551;0
WireConnection;553;0;552;0
WireConnection;553;1;549;0
WireConnection;556;0;547;0
WireConnection;556;1;555;0
WireConnection;183;0;196;0
WireConnection;183;1;478;0
WireConnection;183;2;478;4
WireConnection;578;0;581;0
WireConnection;578;1;265;0
WireConnection;265;0;183;0
WireConnection;586;2;588;0
WireConnection;595;0;594;0
WireConnection;595;1;591;1
WireConnection;585;0;594;1
WireConnection;585;1;591;2
WireConnection;594;0;586;0
WireConnection;540;0;578;0
WireConnection;544;2;553;0
WireConnection;589;0;590;0
WireConnection;589;9;593;0
WireConnection;589;3;587;0
WireConnection;562;0;563;0
WireConnection;562;9;544;0
WireConnection;581;0;583;0
WireConnection;576;0;571;0
WireConnection;582;0;572;0
WireConnection;572;0;576;0
WireConnection;572;1;589;1
WireConnection;572;2;598;0
WireConnection;602;0;599;0
WireConnection;602;1;572;0
WireConnection;601;0;600;0
WireConnection;593;0;595;0
WireConnection;593;1;585;0
WireConnection;593;2;591;3
WireConnection;599;0;576;0
WireConnection;599;1;572;0
WireConnection;577;1;599;0
WireConnection;575;0;574;1
WireConnection;575;1;574;2
WireConnection;580;0;575;0
WireConnection;580;1;587;0
WireConnection;528;0;530;0
WireConnection;528;1;556;0
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;530;3;486;0
WireConnection;486;0;529;3
WireConnection;486;1;568;0
WireConnection;568;0;478;4
WireConnection;568;1;567;0
WireConnection;583;0;582;0
ASEEND*/
//CHKSM=2655B67E321E775EE65BB7E03EB1111690279558