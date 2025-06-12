// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_droplet_vcolored"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_WobbleAmplitude("WobbleAmplitude", Range( 0 , 5)) = 5
		[HDR]_ColorLight("ColorLight", Color) = (0.830163,0,1,1)
		_SpecSize("SpecSize", Range( 0 , 3)) = 3
		_SpecHotspotSize("SpecHotspotSize", Range( 0 , 2)) = 0.9435294
		_LightedIntensity("LightedIntensity", Range( 0 , 1)) = 0
		_WobbleSpeed("WobbleSpeed", Range( -5 , 5)) = 1.156084
		_Float0("Float 0", Range( -5 , 5)) = 0.03406485
		_WobblePeriod("WobblePeriod", Range( 0 , 5)) = 0.2934783
		_FresnelScale("FresnelScale", Range( 0 , 1)) = 0
		_SpecHardness("SpecHardness", Range( -1 , 0.08)) = 0
		_SpecIntensity("SpecIntensity", Range( 0 , 1)) = 1
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
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _WobblePeriod;
			uniform float _WobbleSpeed;
			uniform float _Float0;
			uniform float _WobbleAmplitude;
			uniform float _FresnelScale;
			uniform float _SpecHardness;
			uniform float _SpecSize;
			uniform float _SpecIntensity;
			uniform float _SpecHotspotSize;
			uniform float4 _ColorLight;
			uniform sampler2D _MainTexture;
			uniform float4 _MainTexture_ST;
			uniform float _LightedIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 temp_cast_0 = (_WobblePeriod).xx;
				float2 temp_cast_1 = (_WobbleSpeed).xx;
				float2 panner387 = ( 2.0 * _Time.y * temp_cast_1 + float2( 0,0 ));
				float2 texCoord372 = v.ase_texcoord.xy * temp_cast_0 + panner387;
				float temp_output_388_0 = frac( texCoord372.y );
				float temp_output_377_0 = ( ( temp_output_388_0 * ( 1.0 - temp_output_388_0 ) ) * 0.5 );
				float2 temp_cast_2 = (_WobblePeriod).xx;
				float2 temp_cast_3 = (( ( _WobbleSpeed * 0.3 ) + _Float0 )).xx;
				float2 panner477 = ( 1.5 * _Time.y * temp_cast_3 + float2( 0,0 ));
				float2 texCoord478 = v.ase_texcoord.xy * temp_cast_2 + panner477;
				float temp_output_476_0 = frac( texCoord478.y );
				float temp_output_479_0 = ( ( temp_output_476_0 * ( 1.0 - temp_output_476_0 ) ) * 0.5 );
				float lerpResult481 = lerp( temp_output_377_0 , temp_output_479_0 , 0.5);
				float temp_output_312_0 = ( saturate( (lerpResult481*0.2 + 0.05) ) * _WobbleAmplitude );
				float temp_output_420_0 = saturate( temp_output_312_0 );
				float3 appendResult442 = (float3(( v.ase_normal.x * temp_output_420_0 ) , ( v.ase_normal.y * temp_output_420_0 ) , ( v.ase_normal.z * temp_output_420_0 )));
				float3 temp_output_443_0 = ( appendResult442 * temp_output_420_0 );
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_color = v.color;
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = temp_output_443_0;
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
				float fresnelNdotV495 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode495 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV495, 8.0 ) );
				float smoothstepResult234 = smoothstep( _SpecHardness , 0.09 , (ase_worldNormal.y*_SpecSize + -0.52));
				float smoothstepResult507 = smoothstep( 0.05 , 0.09 , (( ( ase_worldNormal.x * -0.3 ) + ase_worldNormal.y + ( ase_worldNormal.z * -0.04 ) )*_SpecHotspotSize + -0.62));
				float3 appendResult485 = (float3(i.ase_color.r , i.ase_color.g , i.ase_color.b));
				float3 Col486 = appendResult485;
				float2 uv_MainTexture = i.ase_texcoord2.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float4 tex2DNode5 = tex2D( _MainTexture, uv_MainTexture );
				float clampResult340 = clamp( _LightedIntensity , 0.12 , 1.0 );
				
				
				finalColor = saturate( ( ( ( fresnelNode495 + saturate( ( ( ( smoothstepResult234 * 0.7 ) * _SpecIntensity ) + smoothstepResult507 ) ) ) * saturate( ( _ColorLight + float4( ( Col486 * float3( 0.5,0.5,0.5 ) ) , 0.0 ) ) ) ) + ( saturate( saturate( ( tex2DNode5 * float4( appendResult485 , 0.0 ) ) ) ) * clampResult340 ) ) );
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;313.4197,-126.0126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-971.9001,-233.0901;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;283ecf1283a72244383b6e9ab106f330;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1077.951,658.8024;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;102;-816.4828,608.2452;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.91;False;2;FLOAT;0.71;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;244;2993.522,727.9783;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2757.433,689.9656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2290.128,375.3302;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;99;-528.9024,458.3718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;203;-339.5254,528.4761;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-149.8845,245.0792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;346;-297.1524,67.79321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;347;99.25021,121.2554;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;107.074,136.9029;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;246;381.816,362.2217;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;883.2534,523.8331;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;206;547.0458,573.451;Inherit;False;Property;_DetailColor;DetailColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0,0.05555831,0.8117647,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;249;577.7221,364.7443;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;210;1106.337,520.2352;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;379;471.1975,1578.86;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;451;670.3903,2038.141;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;453;900.9851,2031.163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;2154.048,1489.142;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;442;2489.963,1481.548;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;459;1610.275,2083.923;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-763.8899,1650.579;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;382;-931.0353,1815.988;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;388;-1131.13,1653.039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;476;-1100.671,2162.739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;483;-222.6674,2547.277;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;478;-1398.599,2156.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.77;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;372;-1421.059,1570;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;101;721.5789,-14.38262;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;131.4355,317.6274;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;398.0238,894.6229;Inherit;False;Property;_DetailColorIntensity;DetailColorIntensity;6;0;Create;True;0;0;0;False;0;False;3.294118;4.15;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;484;-998.6343,13.48672;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;485;-755.6656,67.23102;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;486;-529.6085,175.4126;Inherit;False;Col;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;487;1942.897,406.4894;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;489;2077.897,469.4894;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;221;1609.694,146.2102;Inherit;False;Property;_ColorLight;ColorLight;3;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.3113208,0.1659399,0.1671413,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;211;1440.434,536.1406;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;488;1518.897,346.4894;Inherit;False;486;Col;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;490;1762.897,483.4894;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;387;-1657.304,1686.529;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;491;-1691.786,1925.71;Inherit;False;Property;_WobblePeriod;WobblePeriod;10;0;Create;True;0;0;0;False;0;False;0.2934783;0.2934783;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;449;-2092.374,1695.372;Inherit;False;Property;_WobbleSpeed;WobbleSpeed;8;0;Create;True;0;0;0;False;0;False;1.156084;1.43;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;492;-1915.64,1959.137;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;493;-1798.639,2178.837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;474;-713.9306,2122.578;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;475;-933.0757,2325.688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;477;-1649.344,2210.729;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;480;-2197.55,2198.142;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.03406485;0.85;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;1866.382,805.583;Inherit;False;Property;_LightedIntensity;LightedIntensity;7;0;Create;True;0;0;0;False;0;False;0;0.714;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;340;2206.459,927.0605;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2340.416,706.0248;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;497;2732.157,-150.0987;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;494;1632.836,-569.818;Inherit;False;Property;_FresnelScale;FresnelScale;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;495;2033.489,-513.9482;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;227;2318.164,88.57131;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;1408.679,-420.2642;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;499;1012.742,35.99043;Inherit;False;Property;_SpecHardness;SpecHardness;12;0;Create;True;0;0;0;False;0;False;0;0;-1;0.08;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;503;563.2106,-151.0177;Inherit;False;Property;_SpecHotspotSize;SpecHotspotSize;5;0;Create;True;0;0;0;False;0;False;0.9435294;0.733;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;220;529.1071,-603.7173;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;258;558.7078,-280.3246;Inherit;False;Property;_SpecSize;SpecSize;4;0;Create;True;0;0;0;False;0;False;3;0.733;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;511;1647.237,-353.1419;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;507;1405.751,-136.1244;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;500;1729.637,48.96468;Inherit;False;Property;_SpecIntensity;SpecIntensity;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;501;1986.381,-289.8617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;504;2094.039,-148.8901;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;502;1157.883,-169.1026;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.62;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;509;1001.502,-703.1381;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;226;1190.673,-570.6583;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;510;797.2493,-802.0728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;806.8245,-481.8643;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;514;1223.451,979.7192;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;513;2735.451,1979.719;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;479;-385.087,2103.677;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;481;227.2601,2127.015;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;-353.4745,1585.625;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;516;-96.10544,2074.639;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;420;1386.965,1756.159;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;2873.059,1625.592;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;447;2162.391,1388.223;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;448;2156.389,1590.759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;2001.834,1023.784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;520;2004.82,1205.95;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;519;1998.847,1113.373;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;530.2541,1829.694;Inherit;False;Property;_WobbleAmplitude;WobbleAmplitude;1;0;Create;True;0;0;0;False;0;False;5;4.61;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;517;1249.24,1523.66;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;4218.186,1251.975;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_droplet_vcolored;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638636402037779825;0;1;True;False;;False;0
Node;AmplifyShaderEditor.NormalVertexDataNode;462;1130.483,1158.806;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;470;1471.817,1139.512;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;471;1558.659,1272.736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;472;1617.117,1349.413;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;1068.634,1695.644;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;515;-133.4348,1877.541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;440;3167.998,1818.776;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.2,0.2,0.2;False;2;FLOAT3;2,2,2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;378;223.6143,1488.048;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.05;False;1;FLOAT;0
WireConnection;97;0;54;2
WireConnection;96;0;97;0
WireConnection;96;1;54;2
WireConnection;24;0;5;0
WireConnection;24;1;485;0
WireConnection;98;0;96;0
WireConnection;102;0;98;0
WireConnection;244;0;223;0
WireConnection;223;0;222;0
WireConnection;223;1;337;0
WireConnection;222;0;497;0
WireConnection;222;1;489;0
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
WireConnection;379;0;378;0
WireConnection;453;0;451;2
WireConnection;446;0;462;2
WireConnection;446;1;420;0
WireConnection;442;0;447;0
WireConnection;442;1;446;0
WireConnection;442;2;448;0
WireConnection;459;0;420;0
WireConnection;375;0;388;0
WireConnection;375;1;382;0
WireConnection;382;0;388;0
WireConnection;388;0;372;2
WireConnection;476;0;478;2
WireConnection;478;0;491;0
WireConnection;478;1;477;0
WireConnection;372;0;491;0
WireConnection;372;1;387;0
WireConnection;101;0;24;0
WireConnection;212;0;349;0
WireConnection;485;0;484;1
WireConnection;485;1;484;2
WireConnection;485;2;484;3
WireConnection;486;0;485;0
WireConnection;487;0;221;0
WireConnection;487;1;490;0
WireConnection;489;0;487;0
WireConnection;211;0;101;0
WireConnection;490;0;488;0
WireConnection;387;2;449;0
WireConnection;492;0;449;0
WireConnection;493;0;492;0
WireConnection;493;1;480;0
WireConnection;474;0;476;0
WireConnection;474;1;475;0
WireConnection;475;0;476;0
WireConnection;477;2;493;0
WireConnection;340;0;338;0
WireConnection;337;0;211;0
WireConnection;337;1;340;0
WireConnection;497;0;495;0
WireConnection;497;1;227;0
WireConnection;495;2;494;0
WireConnection;227;0;504;0
WireConnection;234;0;226;0
WireConnection;234;1;499;0
WireConnection;511;0;234;0
WireConnection;507;0;502;0
WireConnection;501;0;511;0
WireConnection;501;1;500;0
WireConnection;504;0;501;0
WireConnection;504;1;507;0
WireConnection;502;0;509;0
WireConnection;502;1;503;0
WireConnection;509;0;510;0
WireConnection;509;1;220;2
WireConnection;509;2;508;0
WireConnection;226;0;220;2
WireConnection;226;1;258;0
WireConnection;510;0;220;1
WireConnection;508;0;220;3
WireConnection;513;0;442;0
WireConnection;513;1;420;0
WireConnection;479;0;474;0
WireConnection;481;0;377;0
WireConnection;481;1;479;0
WireConnection;377;0;375;0
WireConnection;516;0;479;0
WireConnection;420;0;312;0
WireConnection;443;0;442;0
WireConnection;443;1;420;0
WireConnection;447;0;462;1
WireConnection;447;1;420;0
WireConnection;448;0;462;3
WireConnection;448;1;420;0
WireConnection;518;0;514;1
WireConnection;518;1;420;0
WireConnection;520;0;514;3
WireConnection;520;1;420;0
WireConnection;519;0;514;2
WireConnection;519;1;420;0
WireConnection;517;0;312;0
WireConnection;257;0;244;0
WireConnection;257;1;443;0
WireConnection;470;0;462;1
WireConnection;471;0;462;2
WireConnection;472;0;462;3
WireConnection;312;0;379;0
WireConnection;312;1;111;0
WireConnection;515;0;377;0
WireConnection;440;0;443;0
WireConnection;378;0;481;0
ASEEND*/
//CHKSM=F3D83F19517FA811B1F0DEBA141B368564F5EC1B