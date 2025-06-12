// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_droplet_hardspec"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		[HDR]_Colorize("Colorize", Color) = (0.5849056,0,0,0.9058824)
		_WobbleAmplitude("WobbleAmplitude", Range( 0 , 5)) = 0
		[HDR]_DetailColor("DetailColor", Color) = (0.830163,0,1,1)
		[HDR]_ColorLight("ColorLight", Color) = (0.830163,0,1,1)
		_Normal("Normal", 2D) = "bump" {}
		_Highlight("Highlight", Range( 0 , 1.2)) = 0.9435294
		_DetailColorIntensity("DetailColorIntensity", Range( 0 , 5)) = 3.294118
		_LightedIntensity("LightedIntensity", Range( 0 , 1)) = 0
		_WobbleSpeed("WobbleSpeed", Range( -5 , 5)) = 0.4705882
		_Float0("Float 0", Range( -5 , 5)) = 0.4705882
		_FresnelScale("FresnelScale", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _WobbleSpeed;
			uniform float _Float0;
			uniform float _WobbleAmplitude;
			uniform float _FresnelScale;
			uniform sampler2D _Normal;
			uniform float4 _Normal_ST;
			uniform float _Highlight;
			uniform float4 _ColorLight;
			uniform sampler2D _MainTexture;
			uniform float4 _MainTexture_ST;
			uniform float4 _Colorize;
			uniform float4 _DetailColor;
			uniform float _DetailColorIntensity;
			uniform float _LightedIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 temp_cast_0 = (_WobbleSpeed).xx;
				float2 panner387 = ( 2.0 * _Time.y * temp_cast_0 + float2( 0,0 ));
				float2 texCoord372 = v.ase_texcoord.xy * float2( 1,0.3 ) + panner387;
				float temp_output_388_0 = frac( texCoord372.y );
				float2 temp_cast_1 = (_Float0).xx;
				float2 panner477 = ( 1.5 * _Time.y * temp_cast_1 + float2( 0,0 ));
				float2 texCoord478 = v.ase_texcoord.xy * float2( 1,0.77 ) + panner477;
				float temp_output_476_0 = frac( texCoord478.y );
				float lerpResult481 = lerp( pow( ( ( temp_output_388_0 * ( 1.0 - temp_output_388_0 ) ) * 1.0 ) , 3.19 ) , pow( ( ( temp_output_476_0 * ( 1.0 - temp_output_476_0 ) ) * 1.58 ) , 3.0 ) , v.color.b);
				float temp_output_420_0 = saturate( ( saturate( (lerpResult481*2.0 + 0.0) ) * _WobbleAmplitude ) );
				float3 appendResult442 = (float3(( ( v.ase_normal.x - 0.0 ) * temp_output_420_0 ) , ( ( v.ase_normal.y - 0.5 ) * temp_output_420_0 ) , ( ( ( 1.0 - temp_output_420_0 ) - 0.5 ) * temp_output_420_0 )));
				float3 clampResult440 = clamp( ( appendResult442 * temp_output_420_0 ) , float3( -0.5,-0.5,-0.5 ) , float3( 0.5,0.5,0.5 ) );
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = clampResult440;
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
				float fresnelNdotV484 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode484 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV484, 4.14 ) );
				float2 texCoord230 = i.ase_texcoord2.xy * _Normal_ST.xy + _Normal_ST.zw;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float smoothstepResult234 = smoothstep( 0.01 , 0.02 , (normalizedWorldNormal.y*_Highlight + -0.52));
				float2 uv_MainTexture = i.ase_texcoord2.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float4 tex2DNode5 = tex2D( _MainTexture, uv_MainTexture );
				float4 temp_output_101_0 = saturate( ( tex2DNode5 * _Colorize ) );
				float smoothstepResult212 = smoothstep( 0.0 , 0.5 , tex2DNode5.g);
				float4 temp_output_211_0 = saturate( ( temp_output_101_0 + saturate( ( ( 1.0 - saturate( smoothstepResult212 ) ) * _DetailColor * _DetailColorIntensity ) ) ) );
				float clampResult340 = clamp( _LightedIntensity , 0.12 , 1.0 );
				
				
				finalColor = saturate( ( ( saturate( ( fresnelNode484 + ( ( UnpackNormal( tex2D( _Normal, texCoord230 ) ).g * 0.5 * _Highlight ) + smoothstepResult234 ) ) ) * _ColorLight ) + ( temp_output_211_0 * clampResult340 ) ) );
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1862.266,806.9154;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;97;-1504.12,652.5922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1356.585,738.6542;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;313.4197,-126.0126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-971.9001,-233.0901;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;229;1071.593,-636.3697;Inherit;True;Property;_Normal;Normal;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;225;874.3931,-309.9704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;1052.943,-139.2488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;737.8118,-137.7947;Inherit;False;Property;_Highlight;Highlight;6;0;Create;True;0;0;0;False;0;False;0.9435294;0.72;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1077.951,658.8024;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;102;-816.4828,608.2452;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.91;False;2;FLOAT;0.71;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;244;2993.522,727.9783;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2757.433,689.9656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2290.128,375.3302;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-841.2159,216.237;Inherit;False;Property;_Colorize;Colorize;1;1;[HDR];Create;True;0;0;0;False;0;False;0.5849056,0,0,0.9058824;0.5849056,0.01518268,0.008276951,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;99;-528.9024,458.3718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;203;-339.5254,528.4761;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-149.8845,245.0792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;346;-297.1524,67.79321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;347;99.25021,121.2554;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;107.074,136.9029;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;246;381.816,362.2217;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;883.2534,523.8331;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;206;547.0458,573.451;Inherit;False;Property;_DetailColor;DetailColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.2830189,0,0.002608389,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;209;483.1188,747.9459;Inherit;False;Property;_DetailColorIntensity;DetailColorIntensity;7;0;Create;True;0;0;0;False;0;False;3.294118;1.46;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;249;577.7221,364.7443;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;210;1106.337,520.2352;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;1332.916,339.3854;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;211;1556.656,348.2398;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2490.416,713.0248;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;221;1798.968,340.5208;Inherit;False;Property;_ColorLight;ColorLight;4;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.4150943,0,0.02411549,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;357;1543.277,961.7789;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;934.584,974.3708;Inherit;False;Property;_HeightLight_MinValue;HeightLight_MinValue;11;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;340;2352.459,839.0605;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;2193.382,1090.583;Inherit;False;Property;_LightedIntensity;LightedIntensity;8;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;366;1737.585,717.8712;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;1886.185,780.6717;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;350;1791.705,665.1592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;1041.334,1728.144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;578.0356,1831.187;Inherit;False;Property;_WobbleAmplitude;WobbleAmplitude;2;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;379;471.1975,1578.86;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;3477.295,1056.874;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_droplet_hardspec;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;2669.988,1748.032;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;451;670.3903,2038.141;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;453;900.9851,2031.163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;447;2134.021,1306.099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;2154.048,1489.142;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;448;2174.307,1644.513;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;220;632.1954,-399.3703;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;420;1448.185,1765.118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;462;1317.584,1348.806;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;442;2489.963,1481.548;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;440;2940.93,1715.254;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;-0.5,-0.5,-0.5;False;2;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;471;1739.016,1413.713;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;470;1713.017,1255.113;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;459;1610.275,2083.923;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;472;1720.817,1533.313;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-763.8899,1650.579;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;382;-931.0353,1815.988;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;388;-1131.13,1653.039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;387;-1642.304,1612.529;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;449;-2090.209,1691.042;Inherit;False;Property;_WobbleSpeed;WobbleSpeed;12;0;Create;True;0;0;0;False;0;False;0.4705882;3.18;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;474;-733.4304,2160.279;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;475;-900.5757,2325.688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;476;-1100.671,2162.739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;-2059.749,2200.742;Inherit;False;Property;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;0.4705882;1.48;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;380;-59.50765,1771.055;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;378;220.6143,1488.048;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;481;298.9324,2156.878;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;483;-222.6674,2547.277;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;-353.4745,1585.625;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;482;-70.66771,2132.878;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;477;-1611.844,2122.229;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;478;-1398.599,2156.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.77;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;372;-1421.059,1570;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;479;-327.8148,2095.325;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.58;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;367;1831.184,715.2711;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;353;928.6805,1057.336;Inherit;False;Property;_HeightLight_MaxHeight;HeightLight_MaxHeight;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.5;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;352;1016.488,824.0258;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;364;2133.185,610.3715;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;360;1813.383,983.4709;Inherit;False;Property;_HeightLight_Effect;HeightLight_Effect;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;1032.595,162.2087;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;101;721.5789,-14.38262;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;226;1134.292,-317.4704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;131.4355,317.6274;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;486;2311.323,-402.8499;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;487;2092.191,-775.6776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;488;1421.101,-775.6777;Inherit;False;Property;_FresnelScale;FresnelScale;14;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;233;2024.022,-363.9586;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;1703.898,-160.9875;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;762.1938,-640.2702;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;489;361.6679,-757.2872;Inherit;False;229;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;1486.295,-562.2701;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;227;2259.935,26.35476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;484;1711.755,-714.8079;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;4.14;False;1;FLOAT;0
WireConnection;97;0;54;2
WireConnection;96;0;97;0
WireConnection;96;1;54;2
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;229;1;230;0
WireConnection;225;0;220;2
WireConnection;243;0;230;2
WireConnection;98;0;96;0
WireConnection;102;0;98;0
WireConnection;244;0;223;0
WireConnection;223;0;222;0
WireConnection;223;1;337;0
WireConnection;222;0;227;0
WireConnection;222;1;221;0
WireConnection;99;0;102;0
WireConnection;203;0;99;0
WireConnection;204;1;203;0
WireConnection;346;0;5;2
WireConnection;347;0;346;0
WireConnection;349;0;347;0
WireConnection;246;0;212;0
WireConnection;207;0;249;0
WireConnection;207;1;206;0
WireConnection;207;2;209;0
WireConnection;249;0;246;0
WireConnection;210;0;207;0
WireConnection;205;0;101;0
WireConnection;205;1;210;0
WireConnection;211;0;205;0
WireConnection;337;0;211;0
WireConnection;337;1;340;0
WireConnection;357;0;352;2
WireConnection;357;1;358;0
WireConnection;357;2;353;0
WireConnection;340;0;338;0
WireConnection;366;0;211;0
WireConnection;365;0;366;0
WireConnection;365;1;357;0
WireConnection;350;0;211;0
WireConnection;312;0;379;0
WireConnection;312;1;111;0
WireConnection;379;0;378;0
WireConnection;257;0;244;0
WireConnection;257;1;440;0
WireConnection;443;0;442;0
WireConnection;443;1;420;0
WireConnection;453;0;451;2
WireConnection;447;0;470;0
WireConnection;447;1;420;0
WireConnection;446;0;471;0
WireConnection;446;1;420;0
WireConnection;448;0;472;0
WireConnection;448;1;420;0
WireConnection;420;0;312;0
WireConnection;442;0;447;0
WireConnection;442;1;446;0
WireConnection;442;2;448;0
WireConnection;440;0;443;0
WireConnection;471;0;462;2
WireConnection;470;0;462;1
WireConnection;459;0;420;0
WireConnection;472;0;459;0
WireConnection;375;0;388;0
WireConnection;375;1;382;0
WireConnection;382;0;388;0
WireConnection;388;0;372;2
WireConnection;387;2;449;0
WireConnection;474;0;476;0
WireConnection;474;1;475;0
WireConnection;475;0;476;0
WireConnection;476;0;478;2
WireConnection;380;0;377;0
WireConnection;378;0;481;0
WireConnection;481;0;380;0
WireConnection;481;1;482;0
WireConnection;481;2;483;3
WireConnection;377;0;375;0
WireConnection;482;0;479;0
WireConnection;477;2;480;0
WireConnection;478;1;477;0
WireConnection;372;1;387;0
WireConnection;479;0;474;0
WireConnection;367;0;350;0
WireConnection;364;0;367;0
WireConnection;364;1;365;0
WireConnection;364;2;360;0
WireConnection;100;0;101;0
WireConnection;101;0;24;0
WireConnection;226;0;220;2
WireConnection;226;1;258;0
WireConnection;212;0;349;0
WireConnection;486;0;484;0
WireConnection;486;1;233;0
WireConnection;233;0;235;0
WireConnection;233;1;234;0
WireConnection;234;0;226;0
WireConnection;230;0;489;0
WireConnection;230;1;489;1
WireConnection;235;0;229;2
WireConnection;235;2;258;0
WireConnection;227;0;486;0
WireConnection;484;2;488;0
ASEEND*/
//CHKSM=12B2955186E5F7752B2B23CFC476501E613DD8E2