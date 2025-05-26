// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_simple_color_premult"
{
	Properties
	{
		_ContrastBoost("ContrastBoost", Range( 0 , 5)) = 2.67783
		_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)

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
		Offset 100 , 0
		
		
		
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
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _ContrastBoost;
			uniform half4 _Color0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
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
				half4 break529 = saturate( ( _ContrastBoost * _Color0 * i.ase_color.a ) );
				half4 appendResult530 = (half4(break529.r , break529.g , break529.b , ( break529.a * _Color0.a )));
				
				
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
Node;AmplifyShaderEditor.DynamicAppendNode;530;-609.6335,1645.101;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-1019.554,1612.526;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;333.1688,1600.124;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_simple_color_premult;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;True;True;False;0;False;;255;False;;255;False;;2;False;;3;False;;3;False;;1;False;;1;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;True;100;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638587125945191860;0;1;True;False;;False;0
Node;AmplifyShaderEditor.ColorNode;478;-1950.084,1502.582;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;0.2235292,1,0.4149507,0.8156863;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-1641.657,1469.616;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1993.812,1349.777;Inherit;False;Property;_ContrastBoost;ContrastBoost;0;0;Create;True;0;0;0;False;0;False;2.67783;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-847.3399,1979.032;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;265;-1341.164,1468.079;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;532;-1927.322,1767.905;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;530;3;486;0
WireConnection;529;0;265;0
WireConnection;528;0;530;0
WireConnection;183;0;196;0
WireConnection;183;1;478;0
WireConnection;183;2;532;4
WireConnection;486;0;529;3
WireConnection;486;1;478;4
WireConnection;265;0;183;0
ASEEND*/
//CHKSM=CBE7692CB6707D19E72E3AD982505AD0B3F9EDA9