// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_flash_mask_premult_wonked_fresnel"
{
	Properties
	{
		_Color1("Color 1", Color) = (0.509434,0.509434,0.509434,0.6509804)

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
		Cull Back
		ColorMask RGBA
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half4 _Color1;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
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
				half3 ase_worldNormal = i.ase_texcoord1.xyz;
				half fresnelNdotV589 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode589 = ( -0.66 + 2.93 * pow( max( 1.0 - fresnelNdotV589 , 0.0001 ), 2.18 ) );
				half fresnelNdotV595 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode595 = ( 0.38 + 1.88 * pow( max( 1.0 - fresnelNdotV595 , 0.0001 ), 1.69 ) );
				half temp_output_594_0 = ( ( fresnelNode589 * _Color1.a ) + ( 1.0 - fresnelNode595 ) );
				half fresnelNdotV604 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode604 = ( -0.83 + 3.93 * pow( max( 1.0 - fresnelNdotV604 , 0.0001 ), 7.15 ) );
				half4 break553 = saturate( ( _Color1 + saturate( ( _Color1 * temp_output_594_0 ) ) + saturate( ( fresnelNode604 * 2.25 ) ) ) );
				half smoothstepResult596 = smoothstep( 0.1 , 0.2 , temp_output_594_0);
				half clampResult603 = clamp( smoothstepResult596 , 0.24 , 0.8 );
				half4 appendResult557 = (half4(break553.r , break553.g , break553.b , clampResult603));
				
				
				finalColor = saturate( appendResult557 );
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
Node;AmplifyShaderEditor.BreakToComponentsNode;553;-425.1321,1071.168;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FresnelNode;595;-2236.575,1602.652;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.38;False;2;FLOAT;1.88;False;3;FLOAT;1.69;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;589;-2246.898,1336.451;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.66;False;2;FLOAT;2.93;False;3;FLOAT;2.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;594;-1226.288,1410.077;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;604;-2280.77,1035.671;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.83;False;2;FLOAT;3.93;False;3;FLOAT;7.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;606;-1048.842,1015.047;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;576;-1316.795,837.3163;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;592;-2135.331,715.1735;Inherit;False;Property;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;0.509434,0.509434,0.509434,0.6509804;0.4417856,0,0.5660378,0.1411765;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;600;-1640.181,1027.333;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;591;-1577.265,1613.416;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;557;-19.2387,1074.386;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;596;-919.5373,1376.905;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;607;298.5407,1075.064;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;593;-819.8866,714.5115;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;609;-1061.076,861.8987;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;608;-625.7842,716.8006;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;1186.094,1126.991;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_flash_mask_premult_wonked_fresnel;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;590;-1595.6,1325.479;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;601;-642.8611,1402.895;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;603;-439.5737,1307.827;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.24;False;2;FLOAT;0.8;False;1;FLOAT;0
WireConnection;553;0;608;0
WireConnection;594;0;590;0
WireConnection;594;1;591;0
WireConnection;606;0;600;0
WireConnection;576;0;592;0
WireConnection;576;1;594;0
WireConnection;600;0;604;0
WireConnection;591;0;595;0
WireConnection;557;0;553;0
WireConnection;557;1;553;1
WireConnection;557;2;553;2
WireConnection;557;3;603;0
WireConnection;596;0;594;0
WireConnection;607;0;557;0
WireConnection;593;0;592;0
WireConnection;593;1;609;0
WireConnection;593;2;606;0
WireConnection;609;0;576;0
WireConnection;608;0;593;0
WireConnection;528;0;607;0
WireConnection;590;0;589;0
WireConnection;590;1;592;4
WireConnection;601;0;596;0
WireConnection;603;0;596;0
ASEEND*/
//CHKSM=FF0DEAF3AD115E428512369F0384E7F0C97EB421