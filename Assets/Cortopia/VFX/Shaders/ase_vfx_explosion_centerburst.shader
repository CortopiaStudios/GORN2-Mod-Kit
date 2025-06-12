// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_explosion_centerburst"
{
	Properties
	{
		_Spikes("Spikes", Range( 0 , 10)) = 0.7133961
		[HDR]_ColorLight("ColorLight", Color) = (1,0.4536018,0,1)
		[HDR]_ColorRim("ColorRim", Color) = (0,1.284734,2,1)
		_Contrast("Contrast", Range( 0 , 2)) = 1

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
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Spikes;
			uniform float _Contrast;
			uniform float4 _ColorRim;
			uniform float4 _ColorLight;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( v.ase_normal * ( v.color.r * _Spikes ) );
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
				float fresnelNdotV375 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode375 = ( 0.0 + 1.04 * pow( 1.0 - fresnelNdotV375, 1.33 ) );
				float smoothstepResult409 = smoothstep( 0.36 , 0.54 , fresnelNode375);
				
				
				finalColor = CalculateContrast(_Contrast,saturate( ( saturate( ( _ColorRim * smoothstepResult409 ) ) + ( ( 1.0 - saturate( fresnelNode375 ) ) * _ColorLight ) ) ));
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;2133.667,898.966;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;388;1960.261,828.8039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;221;1541.917,913.9586;Inherit;False;Property;_ColorLight;ColorLight;1;1;[HDR];Create;True;0;0;0;False;0;False;1,0.4536018,0,1;4.464753,2.695749,1.031948,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;392;3167.584,1076.946;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;368;160.0501,1518.882;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;391;2779.163,684.282;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;401;819.8774,1528.63;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;406;349.1316,1248.354;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;16.7009,2192.717;Inherit;False;Property;_Spikes;Spikes;0;0;Create;True;0;0;0;False;0;False;0.7133961;2.11;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;402;479.1587,1919.831;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;3729.521,1632.559;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_explosion_centerburst;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638543035077078726;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;407;2629.915,1478.349;Inherit;False;Property;_Contrast;Contrast;3;0;Create;True;0;0;0;False;0;False;1;1.039;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;408;2963.005,1388.927;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;380;2121.909,439.1588;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;1893.447,370.508;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;375;1170.143,600.8719;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.04;False;3;FLOAT;1.33;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;390;1786.949,841.933;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;376;1510.775,255.3086;Inherit;False;Property;_ColorRim;ColorRim;2;1;[HDR];Create;True;0;0;0;False;0;False;0,1.284734,2,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;409;1592.061,566.0225;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.36;False;2;FLOAT;0.54;False;1;FLOAT;0
WireConnection;389;0;388;0
WireConnection;389;1;221;0
WireConnection;388;0;390;0
WireConnection;392;0;391;0
WireConnection;391;0;380;0
WireConnection;391;1;389;0
WireConnection;401;0;406;0
WireConnection;401;1;402;0
WireConnection;402;0;368;1
WireConnection;402;1;111;0
WireConnection;257;0;408;0
WireConnection;257;1;401;0
WireConnection;408;1;392;0
WireConnection;408;0;407;0
WireConnection;380;0;377;0
WireConnection;377;0;376;0
WireConnection;377;1;409;0
WireConnection;390;0;375;0
WireConnection;409;0;375;0
ASEEND*/
//CHKSM=D9302E0E5EE10AB19066C45C47652B6452E2AEAD