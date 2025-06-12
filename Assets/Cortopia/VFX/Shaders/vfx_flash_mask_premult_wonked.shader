// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_flash_mask_premult_wonked"
{
	Properties
	{
		_FlashTex("FlashTex", 2D) = "white" {}
		_UVWonk("UVWonk", 2D) = "white" {}
		_Float0("Float 0", Float) = 0.2
		_Wonker("Wonker", Range( 0 , 1)) = 0.3
		_ColorMult("ColorMult", Range( 0 , 4)) = 1
		_Alpha("Alpha", Range( 0 , 1)) = 1

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
		ColorMask RGBA
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
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _ColorMult;
			uniform sampler2D _FlashTex;
			uniform sampler2D _UVWonk;
			uniform float _Float0;
			uniform float4 _UVWonk_ST;
			uniform float _Wonker;
			uniform float4 _FlashTex_ST;
			uniform float _Alpha;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
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
				float4 appendResult575 = (float4(i.ase_color.r , i.ase_color.g , i.ase_color.b , 1.0));
				float2 temp_cast_0 = (_Float0).xx;
				float2 uv_UVWonk = i.ase_texcoord1.xy * _UVWonk_ST.xy + _UVWonk_ST.zw;
				float2 panner561 = ( 1.0 * _Time.y * temp_cast_0 + uv_UVWonk);
				float temp_output_564_0 = ( tex2D( _UVWonk, panner561 ).r - 1.0 );
				float2 texCoord570 = i.ase_texcoord1.xy * _FlashTex_ST.xy + _FlashTex_ST.zw;
				float temp_output_538_0 = saturate( tex2D( _FlashTex, ( ( temp_output_564_0 * _Wonker ) + texCoord570 ) ).r );
				float temp_output_540_0 = saturate( i.ase_color.a );
				float4 break553 = saturate( saturate( ( ( appendResult575 * _ColorMult ) * saturate( ( ( ( saturate( temp_output_538_0 ) * temp_output_540_0 ) - ( 1.0 - temp_output_540_0 ) ) / temp_output_540_0 ) ) ) ) );
				float4 color547 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
				float4 appendResult557 = (float4(break553.x , break553.y , break553.z , ( break553.w * ( color547.a * _Alpha ) )));
				float2 texCoord581 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float saferPower588 = abs( ( ( texCoord581.y * ( 1.0 - texCoord581.y ) ) * 3.3 ) );
				
				
				finalColor = ( appendResult557 * saturate( pow( saferPower588 , 1.8 ) ) );
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
Node;AmplifyShaderEditor.SaturateNode;538;-4358.716,497.317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;540;-3829.109,1685.573;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;541;-3375.759,948.8859;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;542;-2656.229,1030.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;543;-3075.211,952.0178;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;544;-2482.252,936.1239;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;545;-2204.756,1245.683;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;548;-1737.252,1153.976;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;549;-1488.349,877.9379;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;550;-1230.851,903.5638;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;552;-959.8752,927.8649;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;553;-825.0751,1072.964;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;555;-638.6054,1365.108;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;556;-4189.821,773.0209;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;558;-4379.38,1008.027;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;559;-5198.904,898.1719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;560;-4841.896,286.778;Inherit;True;Property;_FlashTex;FlashTex;0;0;Create;True;0;0;0;False;0;False;-1;bdbbce3fe6ef1dd4cb99839eac9c2760;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;561;-6004.059,-237.8007;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;562;-6601.624,-427.4274;Inherit;False;534;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleSubtractOpNode;564;-5464.556,-428.9007;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;565;-5777.854,-414.601;Inherit;True;Property;_UVWonk;UVWonk;1;0;Create;True;0;0;0;False;0;False;-1;204cd928e761305469a2ef1af3831454;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;566;-5060.258,65.09894;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;567;-5253.956,-102.6011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;568;-5376.158,-259.9008;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;570;-5640.087,135.2116;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;571;-3904.689,516.6199;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;557;-374.8618,1102.035;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;573;-5851.951,-103.9006;Inherit;False;Property;_Wonker;Wonker;3;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;574;-6318.375,-239.5177;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;569;-6097.012,91.59155;Inherit;False;560;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;563;-6203.197,-426.7072;Inherit;False;0;565;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;539;-4663.959,1247.207;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;576;-1739.282,814.1663;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;528;594.9476,1181.251;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_flash_mask_premult_wonked;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;10;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.VertexColorNode;551;-2235.349,543.8211;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;579;-1721.764,313.132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;577;-2567.917,742.3396;Inherit;False;Property;_ColorMult;ColorMult;4;0;Create;True;0;0;0;False;0;False;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;578;-2294.626,465.5446;Inherit;False;Property;_Alpha;Alpha;5;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;583;-621.5895,1833.753;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;581;-877.3622,1648.055;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;587;252.5928,1472.869;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;547;-2169.281,105.3672;Inherit;False;Constant;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;575;-1891.695,631.9719;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;586;147.4807,1739.152;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;584;-472.6806,1676.085;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;588;-78.51098,1569.221;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;585;-167.8554,1725.138;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3.3;False;1;FLOAT;0
WireConnection;538;0;560;1
WireConnection;540;0;539;4
WireConnection;541;0;538;0
WireConnection;542;0;540;0
WireConnection;543;0;541;0
WireConnection;543;1;540;0
WireConnection;544;0;543;0
WireConnection;544;1;542;0
WireConnection;545;0;544;0
WireConnection;545;1;540;0
WireConnection;548;0;545;0
WireConnection;549;0;576;0
WireConnection;549;1;548;0
WireConnection;550;0;549;0
WireConnection;552;0;550;0
WireConnection;553;0;552;0
WireConnection;555;0;553;3
WireConnection;555;1;579;0
WireConnection;556;0;558;0
WireConnection;558;1;539;4
WireConnection;560;1;566;0
WireConnection;561;0;563;0
WireConnection;561;2;574;0
WireConnection;564;0;565;1
WireConnection;565;1;561;0
WireConnection;566;0;567;0
WireConnection;566;1;570;0
WireConnection;567;0;564;0
WireConnection;567;1;573;0
WireConnection;568;0;564;0
WireConnection;568;1;570;0
WireConnection;568;2;573;0
WireConnection;570;0;569;0
WireConnection;570;1;569;1
WireConnection;571;1;538;0
WireConnection;557;0;553;0
WireConnection;557;1;553;1
WireConnection;557;2;553;2
WireConnection;557;3;555;0
WireConnection;563;0;562;0
WireConnection;563;1;562;1
WireConnection;576;0;575;0
WireConnection;576;1;577;0
WireConnection;528;0;587;0
WireConnection;579;0;547;4
WireConnection;579;1;578;0
WireConnection;583;0;581;2
WireConnection;587;0;557;0
WireConnection;587;1;586;0
WireConnection;575;0;551;1
WireConnection;575;1;551;2
WireConnection;575;2;551;3
WireConnection;586;0;588;0
WireConnection;584;0;581;2
WireConnection;584;1;583;0
WireConnection;588;0;585;0
WireConnection;585;0;584;0
ASEEND*/
//CHKSM=0976F6EA629E46242C777B08C24C527D85484106