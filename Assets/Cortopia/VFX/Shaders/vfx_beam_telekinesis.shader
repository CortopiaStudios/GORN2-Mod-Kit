// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_beam_telekinesis"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_TextureSpeed("Texture Speed", Float) = 0
		[HDR]_BeamColor("Beam Color", Color) = (0,0,0,0)
		_Shaper("Shaper", Range( 0 , 15)) = 0.68
		_Bulge("Bulge", Float) = 0
		_WaveMove("WaveMove", Float) = 0
		_TipMask("TipMask", Range( -0.2 , 0.8)) = 0
		_Texture0("Texture 0", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha
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
			#define ASE_NEEDS_VERT_POSITION
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

			uniform sampler2D _Texture0;
			uniform float _WaveMove;
			uniform float _Shaper;
			uniform float _Bulge;
			uniform float _TipMask;
			uniform float4 _BeamColor;
			uniform sampler2D _MainTexture;
			uniform float _TextureSpeed;
			uniform float4 _MainTexture_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult110 = (float2(( _WaveMove + 1.0 ) , 0.0));
				float2 texCoord72 = v.ase_texcoord.xy * float2( 1,1 ) + appendResult110;
				float temp_output_164_0 = ( (( -0.5 - _Bulge ) + (( tex2Dlod( _Texture0, float4( texCoord72, 0, 0.0) ).r * _Shaper ) - 0.0) * (( 0.5 + _Bulge ) - ( -0.5 - _Bulge )) / (1.0 - 0.0)) / 10.0 );
				float2 appendResult137 = (float2(abs( _WaveMove ) , 0.0));
				float2 texCoord138 = v.ase_texcoord.xy * float2( 1,1 ) + appendResult137;
				float3 appendResult125 = (float3(( temp_output_164_0 * v.vertex.xyz.x ) , ( v.vertex.xyz.y * ( (-0.5 + (( tex2Dlod( _Texture0, float4( texCoord138, 0, 0.0) ).r * _Shaper ) - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) / 15.0 ) ) , ( temp_output_164_0 * v.vertex.xyz.x )));
				float2 texCoord68 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float clampResult163 = clamp( ( ( texCoord68.x * ( 1.0 - texCoord68.x ) ) * 3.0 ) , 0.0 , 0.5 );
				float3 clampResult151 = clamp( ( appendResult125 * clampResult163 ) , float3( -1,-1,-1 ) , float3( 1,1,1 ) );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = clampResult151;
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
				float2 appendResult116 = (float2(_TipMask , 0.0));
				float2 texCoord112 = i.ase_texcoord1.xy * float2( 1,1 ) + appendResult116;
				float smoothstepResult113 = smoothstep( 0.21 , 0.3 , ( 1.0 - texCoord112.x ));
				float2 appendResult21 = (float2(_TextureSpeed , 0.0));
				float2 uv_MainTexture = i.ase_texcoord1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float2 panner14 = ( _Time.y * appendResult21 + uv_MainTexture);
				float4 tex2DNode5 = tex2D( _MainTexture, panner14 );
				float4 appendResult46 = (float4(( ( _BeamColor * tex2DNode5 ) * i.ase_color ).rgb , ( i.ase_color.a * tex2DNode5.r * _BeamColor.a )));
				float2 texCoord54 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult102 = smoothstep( 0.14 , 1.22 , ( ( ( 1.0 - texCoord54.y ) * texCoord54.y ) * 5.0 ));
				float4 temp_output_100_0 = ( ( smoothstepResult113 * saturate( appendResult46 ) ) * saturate( smoothstepResult102 ) );
				
				
				finalColor = temp_output_100_0;
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
Node;AmplifyShaderEditor.CommentaryNode;39;-2145.47,-66.46272;Inherit;False;1429;545;UV Animation;14;19;21;16;14;31;34;29;15;35;36;37;38;42;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2095.47,338.5373;Inherit;False;Property;_NoiseSpeed;Noise Speed;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1903.47,343.5373;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-1941.47,250.5373;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1995.47,107.5372;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1635.344,321.3616;Inherit;False;Property;_NoiseScale;Noise Scale;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;29;-1678.47,192.5372;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2094.471,-16.46273;Inherit;False;Property;_TextureSpeed;Texture Speed;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1358.47,308.5373;Inherit;False;Property;_NoisePower;Noise Power;4;0;Create;True;0;0;0;False;0;False;0;1.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1904.47,-10.46273;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;42;-1409.344,121.3616;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1168.47,222.5372;Inherit;False;Property;_NoiseAmount;Noise Amount;6;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;35;-1167.47,124.5372;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2565.748,1106.896;Inherit;False;Property;_WaveMove;WaveMove;9;0;Create;True;0;0;0;False;0;False;0;1.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-1679.47,57.53727;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;143;-2291.734,1428.782;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;-898.4704,59.53727;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1862.266,806.9154;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-450.6998,-2.389991;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;e117d87646a38e746890c62a71b1cc3b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;137;-2123.99,1498.103;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;23;-351.2382,228.3319;Inherit;False;Property;_BeamColor;Beam Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;2.026555,0,2.344842,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;110;-2120.15,1242.203;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;134;-1545.787,1307.285;Inherit;True;Property;_Texture0;Texture 0;11;0;Create;True;0;0;0;False;0;False;None;072570009bb96ba4b9dcf3d05352f318;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;97;-1504.12,652.5922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-1866.225,1271.741;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-99.38026,-178.8127;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-1870.065,1527.641;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;148.8297,-91.36273;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;135;-1013.737,1434.013;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;-1029.271,1118.597;Inherit;True;Property;_Shape;Shape;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-1159.812,1704.403;Inherit;False;Property;_Shaper;Shaper;5;0;Create;True;0;0;0;False;0;False;0.68;2.93;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1356.585,738.6542;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;147.8297,105.6373;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;472.5944,41.86511;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;114;76.85364,-918.2983;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-593.5635,1076.219;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1077.951,658.8024;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-527.1736,1306.7;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-572.5521,1722.832;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-1320.747,2027.793;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;102;-828.45,689.1136;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.14;False;2;FLOAT;1.22;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;130;-199.5228,1046.55;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;101;761.7111,-19.39914;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;99;-501.0667,625.2788;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-969.6618,2402.621;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;851.6534,-412.5983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;617.3376,1064.961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;1093.69,20.7826;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-789.8791,2083.764;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;30.56212,2082.231;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;1812.69,1518.695;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;139;-2573.617,1499.983;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;157;950.4022,567.5018;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;1656.719,779.4291;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;1619.019,887.3289;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;142;-2453.157,1414.971;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-5.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-531.2862,1481.819;Inherit;False;Constant;_Float3;Float 3;11;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-518.0853,1383.023;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-536.4391,1582.391;Inherit;False;Constant;_Float4;Float 4;11;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-2301.351,1202.402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;163;808.3479,1954.234;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;113;213.3536,-727.1984;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.21;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-293.6464,-694.6979;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-139.9774,-802.6921;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;117;-757.7231,-699.7842;Inherit;False;Property;_TipMask;TipMask;10;0;Create;True;0;0;0;False;0;False;0;-0.2;-0.2;0.8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;1562.418,555.9785;Inherit;False;Property;_Clip;Clip;12;0;Create;True;0;0;0;False;0;False;0;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;147;1661.108,41.95272;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;148;1944.304,43.03495;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;151;2151.136,1170.414;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;125;1330.015,1259.906;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;122;-15.63784,1320.646;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;183;-741.6679,1026.915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-552.4027,1989.41;Inherit;False;Property;_Bulge;Bulge;7;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;59;-66.15096,1770.728;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;-228.4349,1347.011;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;184;-223.0325,1471.267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TangentVertexDataNode;187;-76.67949,1510.622;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;625.3239,1650.368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;591.4968,1367.503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;141;262.1381,1665.709;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;164;139.9446,975.3786;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;149;1843.747,416.9109;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;189;2558.749,761.4438;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_beam_telekinesis;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.VertexColorNode;22;-86.07029,-26.76273;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;34;0;31;0
WireConnection;29;0;15;0
WireConnection;29;2;34;0
WireConnection;29;1;16;0
WireConnection;21;0;19;0
WireConnection;42;0;29;0
WireConnection;42;1;43;0
WireConnection;35;0;42;0
WireConnection;35;1;36;0
WireConnection;14;0;15;0
WireConnection;14;2;21;0
WireConnection;14;1;16;0
WireConnection;143;0;111;0
WireConnection;38;0;14;0
WireConnection;38;1;35;0
WireConnection;38;2;37;0
WireConnection;5;1;14;0
WireConnection;137;0;143;0
WireConnection;110;0;109;0
WireConnection;97;0;54;2
WireConnection;72;1;110;0
WireConnection;24;0;23;0
WireConnection;24;1;5;0
WireConnection;138;1;137;0
WireConnection;25;0;24;0
WireConnection;25;1;22;0
WireConnection;135;0;134;0
WireConnection;135;1;138;0
WireConnection;57;0;134;0
WireConnection;57;1;72;0
WireConnection;96;0;97;0
WireConnection;96;1;54;2
WireConnection;27;0;22;4
WireConnection;27;1;5;1
WireConnection;27;2;23;4
WireConnection;46;0;25;0
WireConnection;46;3;27;0
WireConnection;114;0;112;1
WireConnection;129;0;57;1
WireConnection;129;1;56;0
WireConnection;98;0;96;0
WireConnection;58;0;135;1
WireConnection;58;1;56;0
WireConnection;102;0;98;0
WireConnection;130;0;129;0
WireConnection;130;1;89;0
WireConnection;130;2;90;0
WireConnection;130;3;185;0
WireConnection;130;4;184;0
WireConnection;101;0;46;0
WireConnection;99;0;102;0
WireConnection;70;0;68;1
WireConnection;115;0;113;0
WireConnection;115;1;101;0
WireConnection;161;0;164;0
WireConnection;161;1;122;1
WireConnection;100;0;115;0
WireConnection;100;1;99;0
WireConnection;69;0;68;1
WireConnection;69;1;70;0
WireConnection;71;0;69;0
WireConnection;155;0;125;0
WireConnection;155;1;163;0
WireConnection;139;0;111;0
WireConnection;158;0;157;0
WireConnection;158;1;125;0
WireConnection;156;0;157;0
WireConnection;156;1;125;0
WireConnection;109;0;111;0
WireConnection;163;0;71;0
WireConnection;113;0;114;0
WireConnection;116;0;117;0
WireConnection;112;1;116;0
WireConnection;147;0;100;0
WireConnection;148;0;147;0
WireConnection;148;1;147;1
WireConnection;148;2;147;2
WireConnection;151;0;155;0
WireConnection;125;0;161;0
WireConnection;125;1;162;0
WireConnection;125;2;170;0
WireConnection;59;0;58;0
WireConnection;59;1;89;0
WireConnection;59;2;90;0
WireConnection;59;3;91;0
WireConnection;59;4;92;0
WireConnection;185;0;91;0
WireConnection;185;1;62;0
WireConnection;184;0;92;0
WireConnection;184;1;62;0
WireConnection;170;0;164;0
WireConnection;170;1;122;1
WireConnection;162;0;122;2
WireConnection;162;1;141;0
WireConnection;141;0;59;0
WireConnection;164;0;130;0
WireConnection;149;2;150;0
WireConnection;189;0;100;0
WireConnection;189;1;151;0
ASEEND*/
//CHKSM=4F0F5DE548324D91F17B48F3BC5E528C424F516E