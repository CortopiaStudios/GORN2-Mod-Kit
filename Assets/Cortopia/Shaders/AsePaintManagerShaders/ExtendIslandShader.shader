// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ExtendIslandShader"
{
	Properties
	{
		_OffsetUV("OffsetUV", Float) = 0
		_MainTex_ST("MainTex_ST", Vector) = (0,0,0,0)
		_UVIslands("UVIslands", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_MainTex_TexelSize("MainTex_TexelSize", Vector) = (0,0,0,0)

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

			#define ASE_ABSOLUTE_VERTEX_POS 1


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

			uniform sampler2D _UVIslands;
			uniform float4 _MainTex_ST;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;
			uniform float _OffsetUV;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 unityObjectToClipPos2 = UnityObjectToClipPos( v.vertex.xyz );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float4 vertexValue = unityObjectToClipPos2;
				o.vertex = vertexValue;

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
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
				float2 appendResult5 = (float2(_MainTex_ST.x , _MainTex_ST.y));
				float2 appendResult6 = (float2(_MainTex_ST.z , _MainTex_ST.w));
				float2 temp_output_10_0 = ( ( i.ase_texcoord1.xy * appendResult5 ) + appendResult6 );
				float4 temp_output_2_0_g14 = tex2D( _MainTex, temp_output_10_0 );
				float2 temp_output_4_0_g14 = temp_output_10_0;
				float2 appendResult26 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float2 temp_output_19_0_g14 = appendResult26;
				float temp_output_17_0_g14 = ( _OffsetUV * -1.0 );
				float2 appendResult9_g14 = (float2(temp_output_17_0_g14 , 0.0));
				float temp_output_5_0_g14 = _OffsetUV;
				float2 appendResult10_g14 = (float2(temp_output_5_0_g14 , 0.0));
				float2 appendResult11_g14 = (float2(0.0 , temp_output_5_0_g14));
				float2 appendResult12_g14 = (float2(0.0 , temp_output_17_0_g14));
				float2 appendResult13_g14 = (float2(temp_output_17_0_g14 , temp_output_5_0_g14));
				float2 appendResult14_g14 = (float2(temp_output_5_0_g14 , temp_output_5_0_g14));
				float2 appendResult15_g14 = (float2(temp_output_5_0_g14 , temp_output_17_0_g14));
				float2 appendResult16_g14 = (float2(temp_output_17_0_g14 , temp_output_17_0_g14));
				float4 ifLocalVar6_g14 = 0;
				if( tex2D( _UVIslands, temp_output_10_0 ).b >= 1.0 )
				ifLocalVar6_g14 = temp_output_2_0_g14;
				else
				ifLocalVar6_g14 = max( max( max( max( max( max( max( max( temp_output_2_0_g14 , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult9_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult10_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult11_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult12_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult13_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult14_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult15_g14 ) ) ) ) , tex2D( _MainTex, ( temp_output_4_0_g14 + ( temp_output_19_0_g14 * appendResult16_g14 ) ) ) );
				
				
				finalColor = ifLocalVar6_g14;
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
Node;AmplifyShaderEditor.Vector4Node;4;-950,3.5;Inherit;False;Property;_MainTex_ST;MainTex_ST;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-715,-24.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-713,77.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-649,306.5;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;2;-307,307.5;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;7;-946,-157.5;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-465,-177.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-629,-177.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-295.878,-334.6128;Inherit;True;Property;_UVIslands;UVIslands;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-298.8778,-84.6736;Inherit;True;Property;_ColorMap;ColorMap;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;23;-539.9053,102.3553;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;3;-130.4182,128.0254;Inherit;False;Property;_OffsetUV;OffsetUV;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;86.09473,90.35529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;25;306.0947,69.35529;Inherit;False;Property;_MainTex_TexelSize;MainTex_TexelSize;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;26;530.0947,58.35529;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1068,249;Float;False;True;-1;2;ASEMaterialInspector;100;12;ExtendIslandShader;3db92839211cf6048bd4cdeaca52ecc2;True;Blood;0;0;Blood;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;638270757557352087;0;1;True;False;;False;0
Node;AmplifyShaderEditor.FunctionNode;27;482.2887,-261.8167;Inherit;False;ExtendColor;-1;;14;07a673ebfe8b9ad429b2a28c66ba695a;0;7;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;SAMPLER2D;0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;17;FLOAT;0;False;19;FLOAT2;0,0;False;1;COLOR;0
WireConnection;5;0;4;1
WireConnection;5;1;4;2
WireConnection;6;0;4;3
WireConnection;6;1;4;4
WireConnection;2;0;1;0
WireConnection;10;0;8;0
WireConnection;10;1;6;0
WireConnection;8;0;7;0
WireConnection;8;1;5;0
WireConnection;12;1;10;0
WireConnection;11;0;23;0
WireConnection;11;1;10;0
WireConnection;24;0;3;0
WireConnection;26;0;25;1
WireConnection;26;1;25;2
WireConnection;0;0;27;0
WireConnection;0;1;2;0
WireConnection;27;1;12;3
WireConnection;27;2;11;0
WireConnection;27;3;23;0
WireConnection;27;4;10;0
WireConnection;27;5;3;0
WireConnection;27;17;24;0
WireConnection;27;19;26;0
ASEEND*/
//CHKSM=A26F1C0701DEC43D1F660BD9E2AA587E5C9EE0D7