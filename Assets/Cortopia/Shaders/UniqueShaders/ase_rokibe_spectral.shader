// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_rokibe_spectral"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,1,0.9607843,1)
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_Power("Power", Float) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
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

			uniform half _Bias;
			uniform half _Scale;
			uniform half _Power;
			uniform half4 _Color0;

			
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
				half fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode3 = ( _Bias + _Scale * pow( max( 1.0 - fresnelNdotV3 , 0.0001 ), _Power ) );
				half temp_output_60_0 = saturate( ( 1.0 - fresnelNode3 ) );
				
				
				finalColor = ( temp_output_60_0 * ( temp_output_60_0 + _Color0 ) );
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
Node;AmplifyShaderEditor.FresnelNode;3;-567.3156,-285.5883;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-814.3467,-278.4942;Inherit;False;Property;_Bias;Bias;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-805.449,-110.0842;Inherit;False;Property;_Power;Power;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-820.449,-203.0841;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-239.2942,-286.8675;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;667.6665,-296.8221;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;53;1084.152,-298.8529;Half;False;True;-1;2;ASEMaterialInspector;100;5;ase_rokibe_spectral;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-199.3335,30.17786;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;-21.08765,-285.0766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;488.2432,-187.367;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;2,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;11;212.771,15.78052;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,1,0.9607843,1;0.7490196,0.138933,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;3;1;55;0
WireConnection;3;2;73;0
WireConnection;3;3;74;0
WireConnection;59;0;3;0
WireConnection;77;0;60;0
WireConnection;77;1;54;0
WireConnection;53;0;77;0
WireConnection;60;0;59;0
WireConnection;54;0;60;0
WireConnection;54;1;11;0
ASEEND*/
//CHKSM=C0CEAADBA0F905193386DA42158D63234F9CA1A2