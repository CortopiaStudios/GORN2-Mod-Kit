// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_giblets"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		[HDR]_Colorize("Colorize", Color) = (0,0,0,0)
		_WobbleAmplitude("WobbleAmplitude", Range( 0 , 1)) = 0
		[HDR]_DetailColor("DetailColor", Color) = (0.830163,0,1,1)
		[HDR]_ColorLight("ColorLight", Color) = (0.830163,0,1,1)
		_Normal("Normal", 2D) = "bump" {}
		_Highlight("Highlight", Range( 0 , 1.2)) = 1
		_DetailColorIntensity("DetailColorIntensity", Range( 0 , 5)) = 3
		_LightedIntensity("LightedIntensity", Range( 0 , 1)) = 0
		_HeightLight_MaxHeight("HeightLight_MaxHeight", Range( 0.5 , 4)) = 0.5
		_HeightLight_Effect("HeightLight_Effect", Range( 0 , 1)) = 1
		_HeightLight_MinValue("HeightLight_MinValue", Range( 0 , 1)) = 1
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
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

			uniform float _WobbleAmplitude;
			uniform sampler2D _MainTexture;
			uniform float4 _MainTexture_ST;
			uniform sampler2D _Normal;
			uniform float _Highlight;
			uniform float4 _ColorLight;
			uniform float4 _Colorize;
			uniform float4 _DetailColor;
			uniform float _DetailColorIntensity;
			uniform float _HeightLight_MinValue;
			uniform float _HeightLight_MaxHeight;
			uniform float _HeightLight_Effect;
			uniform float _LightedIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult317 = (float2(0.0 , (1.0 + (( ( _SinTime.w + v.color.b ) * _WobbleAmplitude ) - 0.0) * (3.0 - 1.0) / (1.0 - 0.0))));
				float2 appendResult110 = (float2(0.0 , (( v.color.b * _WobbleAmplitude )*1.0 + -1.0)));
				float2 texCoord72 = v.ase_texcoord.xy * appendResult317 + appendResult110;
				float temp_output_215_0 = ((0.0 + (( ( 1.0 - texCoord72.y ) * texCoord72.y ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0))*1.0 + -1.0);
				float3 appendResult125 = (float3(( temp_output_215_0 + v.ase_tangent.xyz.x ) , ( temp_output_215_0 + v.ase_tangent.xyz.y ) , ( temp_output_215_0 + v.ase_tangent.xyz.z )));
				float2 uv_MainTexture = v.ase_texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float temp_output_71_0 = ( ( uv_MainTexture.y * ( 1.0 - uv_MainTexture.y ) ) * 2.0 );
				float3 clampResult151 = clamp( ( ( appendResult125 + float3( 0,0,0 ) ) * saturate( (pow( temp_output_71_0 , 3.19 )*2.0 + 0.0) ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
				
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
				vertexValue = clampResult151;
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
				float2 uv_MainTexture = i.ase_texcoord1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float4 tex2DNode5 = tex2D( _MainTexture, uv_MainTexture );
				float2 texCoord54 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult102 = smoothstep( -0.91 , 0.71 , ( ( ( 1.0 - texCoord54.y ) * texCoord54.y ) * 5.0 ));
				float temp_output_99_0 = saturate( smoothstepResult102 );
				float smoothstepResult212 = smoothstep( 0.0 , 0.01 , tex2DNode5.g);
				float4 temp_output_211_0 = saturate( ( ( saturate( ( tex2DNode5 * ( _Colorize + ( 1.0 - temp_output_99_0 ) ) ) ) * temp_output_99_0 ) + saturate( ( ( 1.0 - saturate( smoothstepResult212 ) ) * _DetailColor * _DetailColorIntensity ) ) ) );
				float clampResult357 = clamp( WorldPosition.y , _HeightLight_MinValue , _HeightLight_MaxHeight );
				float4 lerpResult364 = lerp( temp_output_211_0 , ( temp_output_211_0 * clampResult357 ) , _HeightLight_Effect);
				float clampResult340 = clamp( _LightedIntensity , 0.12 , 1.0 );
				
				
				finalColor = saturate( ( ( saturate( ( smoothstepResult234 + ( tex2DNode229.b * 0.025 * ( 1.0 - texCoord230.y ) ) ) ) * _ColorLight ) + ( lerpResult364 * clampResult340 ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SaturateNode;101;761.7111,-19.39914;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;70;-969.6618,2402.621;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-789.8791,2083.764;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;313.4197,-126.0126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-971.9001,-233.0901;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;99b2849cf8331454192035a76099ba6b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;762.1938,-640.2702;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;229;1071.593,-636.3697;Inherit;True;Property;_Normal;Normal;5;0;Create;True;0;0;0;False;0;False;-1;None;1feb4ec626ea6ae45989e6328344fd6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;233;1737.194,-332.1703;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;1486.295,-562.2701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;220;632.1954,-399.3703;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;225;874.3931,-309.9704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;1052.943,-139.2488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;1918.194,66.92929;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;1455.095,-64.37054;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.025;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;1943.894,-173.5705;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;226;1134.292,-317.4704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;737.8118,-137.7947;Inherit;False;Property;_Highlight;Highlight;6;0;Create;True;0;0;0;False;0;False;1;0.62;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-1320.747,2027.793;Inherit;True;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;260;970.4635,2183.723;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;262;591.1238,2183.47;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-379.4637,2018.81;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;197;-1162.427,1026.137;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;296;515.083,1587.629;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;304;501.1567,1374.578;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;303;462.3934,1139.958;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;151;1990.955,1466.094;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-969.2325,1216.698;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;266;170.752,1933.633;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;125;1104.74,1395.378;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;305;445.2075,2012.045;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;302;-37.4986,2236.239;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;288;-2164.992,1132.664;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-1449.011,1182.07;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1817.596,1192.314;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;317;-1817.896,1412.711;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;1650.809,1875.146;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;322;1031.642,1722.028;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;141;-652.5249,1703.477;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;122;-459.4791,1226.288;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TangentVertexDataNode;187;-467.25,1460.656;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;215;-261.2262,967.5668;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;276;-664.7191,909.3855;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;227;2138.851,62.91878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;244;2993.522,727.9783;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2757.433,689.9656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2290.128,375.3302;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-841.2159,216.237;Inherit;False;Property;_Colorize;Colorize;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.6698113,0,0.3430741,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;99;-528.9024,458.3718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;1032.595,162.2087;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;342;-274.985,200.7969;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;341;-301.0638,209.9246;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;343;-311.4958,453.7643;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;203;-339.5254,528.4761;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-149.8845,245.0792;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;345;84.90686,-66.51416;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;344;51.00397,-44.34689;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;173.0356,311.2274;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;346;-297.1524,67.79321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;347;99.25021,121.2554;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;107.074,136.9029;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;246;381.816,362.2217;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;883.2534,523.8331;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;206;547.0458,573.451;Inherit;False;Property;_DetailColor;DetailColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.002179349,0.0007429982,0.009658977,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;209;483.1188,747.9459;Inherit;False;Property;_DetailColorIntensity;DetailColorIntensity;7;0;Create;True;0;0;0;False;0;False;3;3.31;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;249;577.7221,364.7443;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;210;1106.337,520.2352;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;1332.916,339.3854;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;211;1556.656,348.2398;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2490.416,713.0248;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;221;1798.968,340.5208;Inherit;False;Property;_ColorLight;ColorLight;4;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.1696593,0.1007305,0.2925324,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;360;1782.183,1005.571;Inherit;False;Property;_HeightLight_Effect;HeightLight_Effect;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;340;2352.459,839.0605;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;2193.382,1090.583;Inherit;False;Property;_LightedIntensity;LightedIntensity;8;0;Create;True;0;0;0;False;0;False;0;0.562;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;366;1737.585,717.8712;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;367;1846.785,690.5713;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;1886.185,780.6717;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;364;2137.085,667.5718;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;350;1791.705,665.1592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;97;-1644.052,458.493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1496.517,544.5552;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1217.883,464.7032;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;102;-956.4151,414.1458;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.91;False;2;FLOAT;0.71;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1970.6,490.9394;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;195;-3373.22,1134.881;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;311;-3009.941,1119.792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-2760.553,1498.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;-2710.941,1810.091;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;310;-3357.042,863.6909;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;-3310.107,1603.561;Inherit;False;Property;_WobbleAmplitude;WobbleAmplitude;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;-3079.705,1361.374;Inherit;False;ScaleMult;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;199;-2219.993,1832.685;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;3526.948,1557.922;Float;False;True;-1;2;ASEMaterialInspector;100;5;Cortopia/VFX/ase_vfx_giblets;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.WorldPosInputsNode;352;1115.217,644.5526;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;357;1498.138,808.3052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;889.4448,820.8972;Inherit;False;Property;_HeightLight_MinValue;HeightLight_MinValue;11;0;Create;True;0;0;0;False;0;False;1;0.568;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;878.3,910.8434;Inherit;False;Property;_HeightLight_MaxHeight;HeightLight_MaxHeight;9;0;Create;True;0;0;0;False;0;False;0.5;1.71;0.5;4;0;1;FLOAT;0
WireConnection;101;0;24;0
WireConnection;70;0;68;2
WireConnection;69;0;68;2
WireConnection;69;1;70;0
WireConnection;24;0;5;0
WireConnection;24;1;345;0
WireConnection;229;1;230;0
WireConnection;233;0;235;0
WireConnection;233;1;226;0
WireConnection;235;0;229;2
WireConnection;225;0;220;2
WireConnection;243;0;230;2
WireConnection;242;0;234;0
WireConnection;242;1;240;0
WireConnection;240;0;229;3
WireConnection;240;2;243;0
WireConnection;234;0;233;0
WireConnection;226;0;220;2
WireConnection;226;1;258;0
WireConnection;260;0;262;0
WireConnection;262;0;71;0
WireConnection;71;0;69;0
WireConnection;197;0;72;2
WireConnection;296;0;215;0
WireConnection;296;1;187;3
WireConnection;304;0;215;0
WireConnection;304;1;187;2
WireConnection;303;0;215;0
WireConnection;303;1;187;1
WireConnection;151;0;306;0
WireConnection;198;0;197;0
WireConnection;198;1;72;2
WireConnection;266;0;302;0
WireConnection;125;0;303;0
WireConnection;125;1;304;0
WireConnection;125;2;296;0
WireConnection;305;0;266;0
WireConnection;302;0;71;0
WireConnection;288;0;196;0
WireConnection;72;0;317;0
WireConnection;72;1;110;0
WireConnection;110;1;288;0
WireConnection;317;1;199;0
WireConnection;306;0;322;0
WireConnection;306;1;305;0
WireConnection;322;0;125;0
WireConnection;215;0;276;0
WireConnection;276;0;198;0
WireConnection;227;0;242;0
WireConnection;244;0;223;0
WireConnection;223;0;222;0
WireConnection;223;1;337;0
WireConnection;222;0;227;0
WireConnection;222;1;221;0
WireConnection;99;0;102;0
WireConnection;100;0;101;0
WireConnection;100;1;342;0
WireConnection;342;0;341;0
WireConnection;341;0;343;0
WireConnection;343;0;99;0
WireConnection;203;0;99;0
WireConnection;204;0;23;0
WireConnection;204;1;203;0
WireConnection;345;0;344;0
WireConnection;344;0;204;0
WireConnection;212;0;349;0
WireConnection;346;0;5;2
WireConnection;347;0;346;0
WireConnection;349;0;347;0
WireConnection;246;0;212;0
WireConnection;207;0;249;0
WireConnection;207;1;206;0
WireConnection;207;2;209;0
WireConnection;249;0;246;0
WireConnection;210;0;207;0
WireConnection;205;0;100;0
WireConnection;205;1;210;0
WireConnection;211;0;205;0
WireConnection;337;0;364;0
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
WireConnection;97;0;54;2
WireConnection;96;0;97;0
WireConnection;96;1;54;2
WireConnection;98;0;96;0
WireConnection;102;0;98;0
WireConnection;311;0;310;4
WireConnection;311;1;195;3
WireConnection;196;0;195;3
WireConnection;196;1;111;0
WireConnection;312;0;311;0
WireConnection;312;1;111;0
WireConnection;318;0;195;3
WireConnection;199;0;312;0
WireConnection;257;0;244;0
WireConnection;257;1;151;0
WireConnection;357;0;352;2
WireConnection;357;1;358;0
WireConnection;357;2;353;0
ASEEND*/
//CHKSM=C8B9C65ACB6B8550A574FA3C121F0990C5EC48D3