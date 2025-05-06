// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_gutsboss_blobs"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "black" {}

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

			uniform sampler2D _TextureSample0;

			
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
				half mulTime9 = _Time.y * -0.02;
				half2 temp_cast_0 = (mulTime9).xx;
				half2 texCoord131 = i.ase_texcoord1.xy * float2( 1,1 ) + temp_cast_0;
				half mulTime99 = _Time.y * 0.03;
				half2 temp_cast_1 = (mulTime99).xx;
				half2 texCoord132 = i.ase_texcoord1.xy * float2( 1.5,1.5 ) + temp_cast_1;
				half4 color135 = IsGammaSpace() ? half4(0.4862745,0.6980392,0,0) : half4(0.2015562,0.4452012,0,0);
				half3 ase_worldNormal = i.ase_texcoord2.xyz;
				half3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				half dotResult124 = dot( normalizedWorldNormal , ase_worldViewDir );
				half temp_output_121_0 = step( 0.7 , ( 1.0 - dotResult124 ) );
				half4 color144 = IsGammaSpace() ? half4(0.6078432,0.6509804,0.427451,1) : half4(0.3277782,0.3813261,0.1529262,1);
				
				
				finalColor = ( ( ( ( ( tex2D( _TextureSample0, texCoord131 ).g * tex2D( _TextureSample0, texCoord132 ).g ) * color135 ) + color135 ) + temp_output_121_0 ) * ( ( 1.0 - temp_output_121_0 ) + color144 ) );
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
Node;AmplifyShaderEditor.SamplerNode;2;430.1611,179.9675;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;e818e05c6181bdf45a7ef5b5003baeeb;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;96;434.5975,389.6308;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;e818e05c6181bdf45a7ef5b5003baeeb;True;0;False;black;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;126;571.425,578.7843;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;28;55.1503,580.1692;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;125;65.44275,727.2228;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;124;439.7667,578.7843;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;121;1029.649,474.2321;Inherit;True;2;0;FLOAT;0.7;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;1311.037,457.452;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;1556.283,307.7225;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1995.554,211.473;Half;False;True;-1;2;ASEMaterialInspector;100;5;ase_gutsboss_blobs;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;1327.419,221.4987;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;1748.254,209.0765;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-119.8909,472.4041;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;847.9919,329.6436;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;1164.948,233.9596;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;1007.964,293.762;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-542.2497,-14.99762;Inherit;False;1;0;FLOAT;-0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;99;-680.5289,435.3268;Inherit;False;1;0;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;-14.6601,-53.09248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;132;-267.3253,558.3884;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;144;1273.034,579.2994;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.6078432,0.6509804,0.427451,1;0.6078432,0.6117647,0.2392157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;135;759.7036,49.1333;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;0.4862745,0.6980392,0,0;0.6117647,0.7254902,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;734.0624,474.2318;Inherit;False;Constant;_Step;Step;1;0;Create;True;0;0;0;False;0;False;0.7;0.6;0;1;0;1;FLOAT;0
WireConnection;2;1;131;0
WireConnection;96;1;132;0
WireConnection;126;0;124;0
WireConnection;124;0;28;0
WireConnection;124;1;125;0
WireConnection;121;0;127;0
WireConnection;121;1;126;0
WireConnection;130;0;121;0
WireConnection;129;0;130;0
WireConnection;129;1;144;0
WireConnection;0;0;128;0
WireConnection;106;0;141;0
WireConnection;106;1;121;0
WireConnection;128;0;106;0
WireConnection;128;1;129;0
WireConnection;137;0;2;2
WireConnection;137;1;96;2
WireConnection;141;0;138;0
WireConnection;141;1;135;0
WireConnection;138;0;137;0
WireConnection;138;1;135;0
WireConnection;131;1;9;0
WireConnection;132;1;99;0
ASEEND*/
//CHKSM=DA12A057763148065B36BD55363C06C2054AEBFA