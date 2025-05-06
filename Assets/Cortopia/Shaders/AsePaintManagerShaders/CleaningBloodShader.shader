// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CleaningBloodShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_CleanDryUpdateSteps("CleanDryUpdateSteps", Int) = 0

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
			Name "Blood"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_VERT_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float4 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform int _CleanDryUpdateSteps;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 unityObjectToClipPos11 = UnityObjectToClipPos( v.vertex.xyz );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float4 vertexValue = unityObjectToClipPos11;
				o.vertex = vertexValue;

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				#endif
				return o;
			}
			
			float4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				float4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord4 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode5 = tex2D( _MainTex, texCoord4 );
				float temp_output_29_0 = ( ( 1.0 / 124.0 ) * _CleanDryUpdateSteps );
				float4 appendResult7 = (float4(( tex2DNode5.r - temp_output_29_0 ) , tex2DNode5.g , tex2DNode5.b , ( tex2DNode5.a - temp_output_29_0 )));
				
				
				finalColor = appendResult7;
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-697,-481.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;158.9178,-377.5822;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;132.5,-680;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;370,-477.5;Inherit;False;FLOAT4;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;5;-468,-506.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;27;747,-169;Float;False;True;-1;2;ASEMaterialInspector;100;12;CleaningBloodShader;3db92839211cf6048bd4cdeaca52ecc2;True;Blood;0;0;Blood;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;11;9,-140.5;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;1;-185,-139.5;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-604.1195,-318.0213;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-601.7421,-243.9241;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;124;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-437.5313,-300.8086;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-270.741,-255.843;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;28;-531.741,-159.843;Inherit;False;Property;_CleanDryUpdateSteps;CleanDryUpdateSteps;1;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
WireConnection;6;0;5;4
WireConnection;6;1;29;0
WireConnection;14;0;5;1
WireConnection;14;1;29;0
WireConnection;7;0;14;0
WireConnection;7;1;5;2
WireConnection;7;2;5;3
WireConnection;7;3;6;0
WireConnection;5;1;4;0
WireConnection;27;0;7;0
WireConnection;27;1;11;0
WireConnection;11;0;1;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;29;0;19;0
WireConnection;29;1;28;0
ASEEND*/
//CHKSM=F2763A086B19239AEBCFC646EE2DFCED4CA492D4