// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_flash_mask_premult"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_FlashTex("FlashTex", 2D) = "white" {}
		_MaskV("MaskV", Float) = 0
		_MaskU("MaskU", Float) = 0
		_FlashU("FlashU", Float) = 0
		_FlashV("FlashV", Float) = 0
		[Toggle]_ErodemanualvertexcolA("Erode manual/vertexcol(A)", Float) = 1
		_ContrastBoost("ContrastBoost", Range( 0 , 10)) = 2.67783
		[HDR]_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)
		_Erode("Erode", Range( 0 , 1)) = 0.5111656
		_PanX("PanX", Range( -10 , 10)) = 0
		_PanY("PanY", Range( -10 , 10)) = 0

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
		Cull Off
		ColorMask RGB
		ZWrite Off
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
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color0;
			uniform float _ContrastBoost;
			uniform sampler2D _Mask;
			uniform float4 _Mask_ST;
			uniform float _MaskU;
			uniform float _MaskV;
			uniform sampler2D _FlashTex;
			uniform float _PanX;
			uniform float _PanY;
			uniform float4 _FlashTex_ST;
			uniform float _FlashU;
			uniform float _FlashV;
			uniform float _ErodemanualvertexcolA;
			uniform float _Erode;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float2 appendResult470 = (float2(_MaskU , _MaskV));
				float2 texCoord481 = i.ase_texcoord1.xy * _Mask_ST.xy + ( _Mask_ST.zw + appendResult470 );
				float4 tex2DNode463 = tex2D( _Mask, texCoord481 );
				float2 appendResult537 = (float2(_PanX , _PanY));
				float2 appendResult469 = (float2(_FlashU , _FlashV));
				float2 texCoord482 = i.ase_texcoord1.xy * _FlashTex_ST.xy + ( _FlashTex_ST.zw + appendResult469 );
				float2 panner508 = ( 0.3 * _Time.y * appendResult537 + texCoord482);
				float temp_output_496_0 = saturate( tex2D( _FlashTex, panner508 ).r );
				float4 break529 = saturate( saturate( ( _Color0 * saturate( ( _ContrastBoost * ( ( ( saturate( ( tex2DNode463.r * temp_output_496_0 ) ) * (( _ErodemanualvertexcolA )?( saturate( i.ase_color.a ) ):( _Erode )) ) - ( 1.0 - (( _ErodemanualvertexcolA )?( saturate( i.ase_color.a ) ):( _Erode )) ) ) / (( _ErodemanualvertexcolA )?( saturate( i.ase_color.a ) ):( _Erode )) ) ) ) ) ) );
				float4 appendResult530 = (float4(break529.r , break529.g , break529.b , ( break529.a * ( _Color0.a * i.ase_color.a ) )));
				
				
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
Node;AmplifyShaderEditor.RangedFloatNode;467;-5735.242,1211.552;Inherit;False;Property;_FlashU;FlashU;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;468;-5739.455,1289.51;Inherit;False;Property;_FlashV;FlashV;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;469;-5537.01,1247.478;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;465;-5719.49,893.7536;Inherit;False;464;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;466;-5402.781,1066.214;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;473;-5742.402,411.3214;Inherit;False;Property;_MaskV;MaskV;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;474;-5742.403,333.3633;Inherit;False;Property;_MaskU;MaskU;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;470;-5516.957,371.2893;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;482;-5344.47,845.0737;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;472;-5696.612,161.401;Inherit;False;463;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;471;-5354.72,322.8273;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;464;-5036.375,826.3401;Inherit;True;Property;_FlashTex;FlashTex;1;0;Create;True;0;0;0;False;0;False;-1;None;183f8562cda0f064580b19cc22d0f39f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;481;-5238.033,158.389;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;496;-4553.195,1036.879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;463;-4937.351,372.7737;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;0;False;0;False;-1;None;278a58f6d52875c4e9adfe3404fb480e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;195;-4739.309,1793.777;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;514;-4023.588,2225.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-4042.955,1978.349;Inherit;False;Property;_Erode;Erode;9;0;Create;True;0;0;0;False;0;False;0.5111656;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;495;-3570.238,1488.448;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;186;-3629.526,1920.78;Inherit;False;Property;_ErodemanualvertexcolA;Erode manual/vertexcol(A);6;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;399;-2850.708,1570.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;521;-2628.864,1944.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-3269.69,1491.58;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-2676.731,1475.686;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;523;-2551.085,1927.885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;401;-2399.235,1785.245;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-2410.115,1529.549;Inherit;False;Property;_ContrastBoost;ContrastBoost;7;0;Create;True;0;0;0;False;0;False;2.67783;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-2139.685,1592.441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;478;-2326.971,676.4628;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;21.56009,4.395978,0.71189,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;265;-1931.731,1693.538;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-1682.828,1417.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;515;-1425.33,1443.126;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;517;-2301.942,923.9631;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;516;-1154.354,1467.427;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-1019.554,1612.526;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;-1931.433,897.1116;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;532;-833.0843,1904.67;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;489;-4384.3,1312.583;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;530;-609.6335,1645.101;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;488;-4573.859,1547.589;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;509;-5393.383,1437.734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;534;-3908.922,677.3562;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;-4220.298,1081.418;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;535;-4096.93,952.4266;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;94.46069,1559.056;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_flash_mask_premult;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.PannerNode;508;-5792.413,1535.238;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;510;-6373.758,1564.541;Inherit;False;Property;_PanX;PanX;10;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;536;-6332.042,1682.698;Inherit;False;Property;_PanY;PanY;11;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;537;-6030.255,1622.34;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
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
WireConnection;464;1;508;0
WireConnection;481;0;472;0
WireConnection;481;1;471;0
WireConnection;496;0;464;1
WireConnection;463;1;481;0
WireConnection;514;0;195;4
WireConnection;495;0;491;0
WireConnection;186;0;479;0
WireConnection;186;1;514;0
WireConnection;399;0;186;0
WireConnection;521;0;186;0
WireConnection;433;0;495;0
WireConnection;433;1;186;0
WireConnection;397;0;433;0
WireConnection;397;1;399;0
WireConnection;523;0;521;0
WireConnection;401;0;397;0
WireConnection;401;1;523;0
WireConnection;183;0;196;0
WireConnection;183;1;401;0
WireConnection;265;0;183;0
WireConnection;486;0;478;0
WireConnection;486;1;265;0
WireConnection;515;0;486;0
WireConnection;516;0;515;0
WireConnection;529;0;516;0
WireConnection;533;0;478;4
WireConnection;533;1;517;4
WireConnection;532;0;529;3
WireConnection;532;1;533;0
WireConnection;489;0;488;0
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;530;3;532;0
WireConnection;488;1;195;4
WireConnection;534;0;463;1
WireConnection;534;1;496;0
WireConnection;534;2;535;0
WireConnection;491;0;463;1
WireConnection;491;1;496;0
WireConnection;528;0;530;0
WireConnection;508;0;482;0
WireConnection;508;2;537;0
WireConnection;537;0;510;0
WireConnection;537;1;536;0
ASEEND*/
//CHKSM=535DBAF68BED9FE59E01E34993F5E67E58AC718A