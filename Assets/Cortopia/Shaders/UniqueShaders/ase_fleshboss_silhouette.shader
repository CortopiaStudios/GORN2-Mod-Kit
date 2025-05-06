// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_fleshboss_silhouette"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.8509804,0.5254902,0.5686275,1)

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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


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
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample0;
			uniform float4 _Color0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.vertex;
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
				float2 appendResult29 = (float2(4.2 , 2.038));
				
				
				finalColor = saturate( ( ( tex2D( _TextureSample0, ((WorldPosition).xy*0.114 + appendResult29) ) * _Color0 ) * ( ( ( i.ase_texcoord1.xyz.y * 0.49 ) - 2.03 ) + 1.98 ) ) );
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
Node;AmplifyShaderEditor.CommentaryNode;48;163.8,-614.1987;Inherit;False;228;187;World projected background;1;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;213.7999,-564.1989;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-224.562,40.98401;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;77;47.43848,-123.0159;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;298.438,-203.016;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;655.438,-479.016;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;75;-680.5615,-53.01587;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;32;-493.2704,-142.9584;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-227.8002,-668.9996;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;26;-474.7704,-644.6584;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-725.67,-479.5585;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;23;-701.3409,-695.609;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-985.171,-715.8941;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-947.8719,-406.7584;Inherit;False;Constant;_Offset_V;Offset_V;7;0;Create;True;0;0;0;False;0;False;2.038;1.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-944.172,-479.5583;Inherit;False;Constant;_Offset_U;Offset_U;6;0;Create;True;0;0;0;False;0;False;4.2;3.505;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-707.7629,-621.7853;Inherit;False;Constant;_Scale;Scale;5;0;Create;True;0;0;0;False;0;False;0.114;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;94;908.438,-478.016;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;82;1107.2,-479.2999;Float;False;True;-1;2;ASEMaterialInspector;100;5;ase_fleshboss_silhouette;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;2;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-952.5,10.49977;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-511.562,228.984;Inherit;False;Constant;_ScaleFade;ScaleFade;4;0;Create;True;0;0;0;False;0;False;0.49;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-143.6718,283.7415;Inherit;False;Constant;_ScaleDistance;ScaleDistance;3;0;Create;True;0;0;0;False;0;False;2.03;1.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;131.438,119.984;Inherit;False;Constant;_Lighten;Lighten;2;0;Create;True;0;0;0;False;0;False;1.98;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-153.2999,-449.6001;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.8509804,0.5254902,0.5686275,1;0.8509804,0.5254902,0.5686275,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;3;0;14;0
WireConnection;3;1;1;0
WireConnection;85;0;2;2
WireConnection;85;1;87;0
WireConnection;77;0;85;0
WireConnection;77;1;45;0
WireConnection;91;0;77;0
WireConnection;91;1;92;0
WireConnection;90;0;3;0
WireConnection;90;1;91;0
WireConnection;75;0;2;1
WireConnection;75;1;2;2
WireConnection;32;0;75;0
WireConnection;14;1;26;0
WireConnection;26;0;23;0
WireConnection;26;1;22;0
WireConnection;26;2;29;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;23;0;25;0
WireConnection;94;0;90;0
WireConnection;82;0;94;0
ASEEND*/
//CHKSM=AFABC54C5FA7E4CEDB7294BA25F302A1745B938D