// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_impact_stars"
{
	Properties
	{
		_Highlight("Highlight", Range( 0 , 2)) = 2.67783
		_Boost("Boost", Range( 0 , 2)) = 2.67783
		[HDR]_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Off
		ColorMask RGB
		ZWrite On
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

			uniform half _Highlight;
			uniform half4 _Color0;
			uniform half _Boost;

			
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
				half fresnelNdotV536 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode536 = ( 0.0 + 2.0 * pow( max( 1.0 - fresnelNdotV536 , 0.0001 ), 0.83 ) );
				
				
				finalColor = saturate( ( ( ( ( 1.0 - saturate( fresnelNode536 ) ) * _Highlight ) + _Color0 ) * _Boost ) );
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
Node;AmplifyShaderEditor.RangedFloatNode;467;-5735.242,1211.552;Inherit;False;Property;_FlashU;FlashU;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;468;-5739.455,1289.51;Inherit;False;Property;_FlashV;FlashV;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;469;-5537.01,1247.478;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;465;-5719.49,893.7536;Inherit;False;464;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;466;-5402.781,1066.214;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;473;-5742.402,411.3214;Inherit;False;Property;_MaskV;MaskV;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;474;-5742.403,333.3633;Inherit;False;Property;_MaskU;MaskU;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;510;-6167.339,1665.942;Inherit;False;Property;_Pan;Pan;9;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;470;-5516.957,371.2893;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;482;-5344.47,845.0737;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;472;-5696.612,161.401;Inherit;False;463;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;471;-5354.72,322.8273;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;508;-5792.413,1535.238;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;464;-5036.375,826.3401;Inherit;True;Property;_FlashTex;FlashTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;481;-5238.033,158.389;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;496;-4553.195,1036.879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;463;-4937.351,372.7737;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;509;-5393.383,1437.734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;534;-3908.922,677.3562;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;-4220.298,1081.418;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;535;-4096.93,952.4266;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;541;-2647.722,1176.111;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;543;-2348.722,1203.111;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;-1.87;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;549;-2605.722,803.111;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-1285.919,1397.107;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;265;-1051.555,1681.451;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;554;-1808.923,879.0114;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;555;-1927.522,953.0112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;550;-2636.723,998.811;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;552;-2401.123,961.111;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;547;-1839.822,1099.111;Inherit;False;2;2;0;FLOAT;0.25;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-2157.438,1262.761;Inherit;False;Property;_Highlight;Highlight;6;0;Create;True;0;0;0;False;0;False;2.67783;0.59;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;556;-1991.113,1848.36;Inherit;False;Property;_Boost;Boost;7;0;Create;True;0;0;0;False;0;False;2.67783;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;553;-1998.023,703.0112;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;537;-1526.258,1129.374;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;536;-2309.256,719.6181;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0.83;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;94.46069,1559.056;Half;False;True;-1;2;ASEMaterialInspector;100;5;vfx_impact_stars;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;1;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-1847.462,1354.867;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;-2017.328,1503.751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;517;-2317.89,1670.549;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;478;-2334.813,1445.943;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;0.7490196,0.138933,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;469;0;467;0
WireConnection;469;1;468;0
WireConnection;466;0;465;1
WireConnection;466;1;469;0
WireConnection;470;0;474;0
WireConnection;470;1;473;0
WireConnection;482;0;465;0
WireConnection;482;1;466;0
WireConnection;471;0;472;1
WireConnection;471;1;470;0
WireConnection;508;0;482;0
WireConnection;508;2;510;0
WireConnection;464;1;508;0
WireConnection;481;0;472;0
WireConnection;481;1;471;0
WireConnection;496;0;464;1
WireConnection;463;1;481;0
WireConnection;534;0;463;1
WireConnection;534;1;496;0
WireConnection;534;2;535;0
WireConnection;491;0;463;1
WireConnection;491;1;496;0
WireConnection;543;0;541;1
WireConnection;543;2;541;3
WireConnection;183;0;537;0
WireConnection;183;1;556;0
WireConnection;265;0;183;0
WireConnection;554;0;536;0
WireConnection;555;0;554;0
WireConnection;552;0;549;3
WireConnection;552;1;550;3
WireConnection;547;0;555;0
WireConnection;547;1;196;0
WireConnection;553;0;536;0
WireConnection;537;0;547;0
WireConnection;537;1;478;0
WireConnection;528;0;265;0
WireConnection;486;1;533;0
WireConnection;533;0;478;4
WireConnection;533;1;517;4
ASEEND*/
//CHKSM=7108839B0E74BDF87EAC355F25AA77544664A58D