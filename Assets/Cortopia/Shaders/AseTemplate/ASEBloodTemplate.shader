Shader /*ase_name*/ "Hidden/Templates/BloodTemplate" /*end*/
{
	Properties
	{
		/*ase_props*/
	}
	
	SubShader
	{
		/*ase_subshader_options:Name=Additional Options
			Option:Vertex Position,InvertActionOnDeselection:Absolute,Relative:Relative
				Absolute:SetDefine:ASE_ABSOLUTE_VERTEX_POS 1
				Absolute:SetPortName:1,Vertex Position
				Relative:SetPortName:1,Vertex Offset
		*/
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		/*ase_all_modules*/
		
		/*ase_pass*/
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
			/*ase_pragma*/

			struct appdata
			{
				float4 vertex : POSITION;
				/*ase_vdata:p=p;c=c*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float4 worldPos : TEXCOORD0;
				#endif
				/*ase_interp(1,):sp=sp.xyzw;wp=tc0*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			/*ase_globals*/
			
			v2f vert ( appdata v /*ase_vert_input*/)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				/*ase_vert_code:v=appdata;o=v2f*/
				float4 vertexValue = float4(0, 0, 0, 0);
				vertexValue = /*ase_vert_out:Vertex Offset;Float4*/vertexValue/*end*/;

				o.vertex = vertexValue;

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				#endif
				return o;
			}
			
			float4 frag (v2f i /*ase_frag_input*/) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				float4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				/*ase_local_var:wp*/float3 WorldPosition = i.worldPos;
				#endif
				/*ase_frag_code:i=v2f*/
				
				finalColor = /*ase_frag_out:Frag Color;Float4*/fixed4(1,1,1,1)/*end*/;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}
