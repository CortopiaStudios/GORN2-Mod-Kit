// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/VFX/ase_vfx_solids"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		[HDR]_Colorize("Colorize", Color) = (0.5849056,0,0,0.9058824)
		[HDR]_DetailColor("DetailColor", Color) = (0.830163,0,1,1)
		[HDR]_ColorLight("ColorLight", Color) = (0.830163,0,1,1)
		_Normal("Normal", 2D) = "bump" {}
		_Highlight("Highlight", Range( 0 , 1.2)) = 0.9435294
		_DetailColorIntensity("DetailColorIntensity", Range( 0 , 5)) = 3.294118
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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

			uniform sampler2D _Normal;
			uniform half _Highlight;
			uniform half4 _ColorLight;
			uniform sampler2D _MainTexture;
			uniform half4 _MainTexture_ST;
			uniform half4 _Colorize;
			uniform half4 _DetailColor;
			uniform half _DetailColorIntensity;
			uniform half _HeightLight_MinValue;
			uniform half _HeightLight_MaxHeight;
			uniform half _HeightLight_Effect;
			uniform half _LightedIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
				half2 texCoord230 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				half3 tex2DNode229 = UnpackNormal( tex2D( _Normal, texCoord230 ) );
				half3 ase_worldNormal = i.ase_texcoord2.xyz;
				half3 normalizedWorldNormal = normalize( ase_worldNormal );
				half smoothstepResult234 = smoothstep( -0.45 , 0.13 , ( ( tex2DNode229.g * 0.5 ) + (normalizedWorldNormal.y*_Highlight + -0.52) ));
				float2 uv_MainTexture = i.ase_texcoord1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				half4 tex2DNode5 = tex2D( _MainTexture, uv_MainTexture );
				half4 temp_output_101_0 = saturate( ( tex2DNode5 * _Colorize ) );
				half smoothstepResult212 = smoothstep( 0.0 , 0.01 , tex2DNode5.g);
				half4 temp_output_211_0 = saturate( ( temp_output_101_0 + saturate( ( ( 1.0 - saturate( smoothstepResult212 ) ) * _DetailColor * _DetailColorIntensity ) ) ) );
				half clampResult357 = clamp( WorldPosition.y , _HeightLight_MinValue , _HeightLight_MaxHeight );
				half4 lerpResult364 = lerp( temp_output_211_0 , ( temp_output_211_0 * clampResult357 ) , _HeightLight_Effect);
				half clampResult340 = clamp( _LightedIntensity , 0.12 , 1.0 );
				
				
				finalColor = saturate( ( ( saturate( smoothstepResult234 ) * _ColorLight ) + ( lerpResult364 * clampResult340 ) ) );
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
Node;AmplifyShaderEditor.SamplerNode;5;-971.9001,-233.0901;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;230;762.1938,-640.2702;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;229;1071.593,-636.3697;Inherit;True;Property;_Normal;Normal;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;233;1737.194,-332.1703;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;1052.943,-139.2488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;737.8118,-137.7947;Inherit;False;Property;_Highlight;Highlight;5;0;Create;True;0;0;0;False;0;False;0.9435294;0.535;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;227;2138.851,62.91878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;244;2993.522,727.9783;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2757.433,689.9656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2290.128,375.3302;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-841.2159,216.237;Inherit;False;Property;_Colorize;Colorize;1;1;[HDR];Create;True;0;0;0;False;0;False;0.5849056,0,0,0.9058824;0.8113208,0,0,0.9058824;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;346;-297.1524,67.79321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;347;99.25021,121.2554;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;349;107.074,136.9029;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;246;381.816,362.2217;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;883.2534,523.8331;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;206;547.0458,573.451;Inherit;False;Property;_DetailColor;DetailColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.8490566,0,0.008957971,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;209;483.1188,747.9459;Inherit;False;Property;_DetailColorIntensity;DetailColorIntensity;6;0;Create;True;0;0;0;False;0;False;3.294118;1.46;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;249;577.7221,364.7443;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;210;1106.337,520.2352;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;1332.916,339.3854;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;211;1556.656,348.2398;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2490.416,713.0248;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;221;1798.968,340.5208;Inherit;False;Property;_ColorLight;ColorLight;3;1;[HDR];Create;True;0;0;0;False;0;False;0.830163,0,1,1;0.4528302,0.1601994,0.2347167,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;357;1543.277,961.7789;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;934.584,974.3708;Inherit;False;Property;_HeightLight_MinValue;HeightLight_MinValue;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;340;2352.459,839.0605;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;2193.382,1090.583;Inherit;False;Property;_LightedIntensity;LightedIntensity;7;0;Create;True;0;0;0;False;0;False;0;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;366;1737.585,717.8712;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;1886.185,780.6717;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;350;1791.705,665.1592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;220;632.1954,-399.3703;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;367;1831.184,715.2711;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;353;928.6805,1057.336;Inherit;False;Property;_HeightLight_MaxHeight;HeightLight_MaxHeight;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.5;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;352;1016.488,824.0258;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;364;2133.185,610.3715;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;360;1813.383,983.4709;Inherit;False;Property;_HeightLight_Effect;HeightLight_Effect;9;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;1032.595,162.2087;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;101;721.5789,-14.38262;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;1918.194,66.92929;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;1455.095,-64.37054;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.005;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;1486.295,-562.2701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;226;1134.292,-317.4704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.73;False;2;FLOAT;-0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;1943.894,-173.5705;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.45;False;2;FLOAT;0.13;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;4386.633,1008.246;Half;False;True;-1;2;ASEMaterialInspector;100;5;Cortopia/VFX/ase_vfx_solids;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;131.4355,317.6274;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;1;FLOAT;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;229;1;230;0
WireConnection;233;0;235;0
WireConnection;233;1;226;0
WireConnection;243;0;230;2
WireConnection;227;0;234;0
WireConnection;244;0;223;0
WireConnection;223;0;222;0
WireConnection;223;1;337;0
WireConnection;222;0;227;0
WireConnection;222;1;221;0
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
WireConnection;337;0;364;0
WireConnection;337;1;340;0
WireConnection;357;0;352;2
WireConnection;357;1;358;0
WireConnection;357;2;353;0
WireConnection;340;0;338;0
WireConnection;366;0;211;0
WireConnection;365;0;366;0
WireConnection;365;1;357;0
WireConnection;350;0;211;0
WireConnection;367;0;350;0
WireConnection;364;0;367;0
WireConnection;364;1;365;0
WireConnection;364;2;360;0
WireConnection;100;0;101;0
WireConnection;101;0;24;0
WireConnection;242;1;240;0
WireConnection;240;0;229;3
WireConnection;240;2;243;0
WireConnection;235;0;229;2
WireConnection;226;0;220;2
WireConnection;226;1;258;0
WireConnection;234;0;233;0
WireConnection;257;0;244;0
WireConnection;212;0;349;0
ASEEND*/
//CHKSM=A9A9C8CFC929C0D51D6CE0698F26BA6273D658A5