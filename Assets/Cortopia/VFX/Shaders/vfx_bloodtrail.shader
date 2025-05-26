// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_bloodtrail"
{
	Properties
	{
		_Erode("Erode", Range( 0 , 0.98)) = 0
		_Spec("Spec", Range( 0 , 1)) = 1
		_Main("Main", 2D) = "white" {}
		[HDR]_BaseColor("BaseColor", Color) = (0.3301887,0,0,1)
		[HDR]_Lucencycol("Lucencycol", Color) = (0.6509434,0,0.4581906,1)
		[HDR]_SpecColor("SpecColor", Color) = (27.3029,1.748462,1.748462,0)
		[Normal]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Translucency("Translucency", Range( 0 , 1)) = 1
		_Panner_Main("Panner_Main", Vector) = (0,0,0,0)
		_Panner_Normal("Panner_Normal", Vector) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
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
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample1;
			uniform float2 _Panner_Normal;
			uniform float4 _TextureSample1_ST;
			uniform float _Spec;
			uniform float _Erode;
			uniform float4 _SpecColor;
			uniform sampler2D _Main;
			uniform float2 _Panner_Main;
			uniform float4 _Main_ST;
			uniform float4 _BaseColor;
			uniform float _Translucency;
			uniform float4 _Lucencycol;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
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
				float2 texCoord924 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float2 panner926 = ( 1.0 * _Time.y * _Panner_Normal + texCoord924);
				float3 tex2DNode668 = UnpackScaleNormal( tex2D( _TextureSample1, panner926 ), 2.0 );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal750 = tex2DNode668;
				float3 worldNormal750 = normalize( float3(dot(tanToWorld0,tanNormal750), dot(tanToWorld1,tanNormal750), dot(tanToWorld2,tanNormal750)) );
				float smoothstepResult782 = smoothstep( 0.5 , 2.0 , ( ( worldNormal750.y + ( tex2DNode668.g * 0.5 ) ) * 2.0 ));
				float temp_output_724_0 = ( i.ase_color.a * _Erode );
				float temp_output_470_0 = saturate( ( 1.0 - temp_output_724_0 ) );
				float2 texCoord915 = i.ase_texcoord1.xy * _Main_ST.xy + _Main_ST.zw;
				float2 panner916 = ( 1.0 * _Time.y * _Panner_Main + texCoord915);
				float4 tex2DNode533 = tex2D( _Main, panner916 );
				float A563 = tex2DNode533.r;
				float temp_output_610_0 = ( saturate( ( ( tex2DNode533.g - temp_output_470_0 ) / ( 1.0 - tex2DNode533.r ) ) ) * A563 );
				float Erosion819 = temp_output_610_0;
				float4 appendResult841 = (float4(_SpecColor.r , _SpecColor.g , _SpecColor.b , ( _SpecColor.a * Erosion819 )));
				float4 temp_output_644_0 = ( saturate( ( ( saturate( ( saturate( smoothstepResult782 ) - ( ( 1.0 - _Spec ) + 0.23 ) ) ) / temp_output_470_0 ) * _Spec ) ) * appendResult841 );
				float4 GradSpec559 = temp_output_644_0;
				float4 break813 = GradSpec559;
				float4 appendResult855 = (float4(break813.x , break813.y , break813.z , 0.0));
				float Translucency690 = ( 1.0 - saturate( ( tex2DNode533.b * 1.0 ) ) );
				float Erodeval744 = temp_output_724_0;
				float clampResult747 = clamp( ( ( 1.0 - Erodeval744 ) * 1.0 ) , 0.0 , 1.0 );
				float temp_output_694_0 = ( saturate( ( Translucency690 * _Translucency * clampResult747 ) ) * 1.0 );
				float temp_output_862_0 = saturate( temp_output_694_0 );
				float clampResult773 = clamp( temp_output_862_0 , 0.1 , 0.2 );
				float4 temp_cast_0 = (clampResult773).xxxx;
				float temp_output_771_0 = saturate( A563 );
				float4 temp_cast_1 = (( 1.0 - temp_output_771_0 )).xxxx;
				float4 break716 = saturate( ( ( saturate( ( ( A563 * _BaseColor ) - temp_cast_0 ) ) + ( ( ( _Lucencycol * temp_output_862_0 ) - temp_cast_1 ) * ( temp_output_771_0 * 1.0 ) ) ) * temp_output_610_0 ) );
				float4 appendResult715 = (float4(break716.r , break716.g , break716.b , break716.a));
				
				
				finalColor = saturate( ( appendResult855 + appendResult715 ) );
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
Node;AmplifyShaderEditor.SimpleDivideOpNode;464;4781.693,3315.985;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;465;5033.833,3302.487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;556;4404.744,4065.735;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;5241.07,3534.751;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;563;4790.996,3571.298;Inherit;True;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;466;4586.965,3263.874;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;467;4572.914,3383.089;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;641;3354.363,4403.878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;703;3541.925,4397.483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;555;4143.061,4215.467;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;553;3971.959,4297.159;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;740;3832.49,4229.926;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;648;3428.779,4150.755;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;782;3658.225,4232.918;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;794;3889.412,4407.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;663;3609.409,4058.484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;792;3626.489,4074.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;533;3851.148,3462.446;Inherit;True;Property;_Main;Main;2;0;Create;True;0;0;0;False;0;False;-1;adb623358578bd843b134582a3e26712;adb623358578bd843b134582a3e26712;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;733;4410.836,2941.921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;691;4539.938,2941.574;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;690;4711.478,2935.601;Inherit;True;Translucency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;785;4241.618,3510.865;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;784;4293.148,3300.667;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;783;4268.741,3308.804;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;786;4171.097,3422.718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;789;4196.864,3413.226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;470;3478.434,3330.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;596;2932.177,3233.737;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;724;3194.612,3322.728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;597;3332.347,3321.36;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;793;3593.18,3385.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;642;4680.879,4502.364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;547;5707.509,2239.288;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.4528302,0.4528302,0.4528302,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;746;3206.794,2117.884;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;693;3461.526,1394.333;Inherit;True;690;Translucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;781;3909.81,1679.284;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;818;7309.372,2462.15;Inherit;True;799;BaseAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;643;4131.375,4691.313;Inherit;False;Property;_SpecColor;SpecColor;5;1;[HDR];Create;True;0;0;0;False;0;False;27.3029,1.748462,1.748462,0;1.129638,0.3463512,0.7223288,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;843;4442.79,4859.315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;841;4628.797,4708.876;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;840;5240.583,4799.092;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;811;7015.986,2679.566;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;813;6510.788,2798.066;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;827;7055.603,2895.848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;829;7735.639,2521.666;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;830;7991.062,2591.785;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;822;7517.267,2791.449;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;814;6758.492,2646.264;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;821;6797.462,2857.249;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;855;6734.931,3063.667;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;644;4920.051,4687.97;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;860;4866.921,4550.422;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;816;8183.279,2824.553;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;820;7278.363,2772.949;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;723;6470.223,3358.006;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;561;6246.589,2803.669;Inherit;True;559;GradSpec;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;592;4204.11,2940.747;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;747;3500.858,2109.994;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;745;3365.295,2116.561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;900;8384.767,3961.224;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;897;7829.492,4096.463;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;903;8034.767,4098.224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;887;8532.12,3956.188;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;895;8163.12,3790.188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;868;7824.006,3786.058;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;866;7601.539,4050.902;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;870;7139.181,4163.648;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;877;7242.514,3545.408;Inherit;True;2;2;0;FLOAT;0.24;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;873;7251.037,3782.502;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;879;7436.55,3557.049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;859;6701.431,3360.034;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;861;6593.944,3875.273;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;806;6102.805,3785.989;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;832;6125.972,4103.87;Inherit;True;831;SpecBaseAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;833;6379.658,3938.792;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;802;5566.116,3853.651;Inherit;True;800;LucencyAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;896;5840.176,3863.122;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;807;5843.901,3959.476;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;901;8215.145,4241.688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;857;8409.674,2836.487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;714;9452.333,3354.414;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_bloodtrail;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;834;9239.483,3342.123;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;560;8948.812,3287.15;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;715;8709.947,3358.449;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;907;6976.647,3135.955;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;906;6976.729,3079.589;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;905;7016.907,3291.499;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;908;7070.332,3060.724;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;909;6943.99,3333.346;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;904;6983.745,3246.122;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;910;7263.709,3196.646;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;911;7959.754,3292.694;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;795;6122.352,3378.079;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;797;6045.803,3343.238;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;796;5999.496,2364.224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;772;5092.689,2020.891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;700;5471.549,2025.672;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;774;5278.658,1679.337;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;698;4963.422,1310.892;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;697;4363.584,1304.358;Inherit;False;Property;_Lucencycol;Lucencycol;4;1;[HDR];Create;True;0;0;0;False;0;False;0.6509434,0,0.4581906,1;1.056604,0.08472767,0.1152578,0.1333333;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;694;4117.809,1683.405;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;862;4698.938,1688.512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;780;5421.166,2315.326;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;768;5110.188,2311.707;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;773;4905.781,2201.069;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;4700.058,2421.193;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;567;4097,2416.982;Inherit;False;Property;_BaseColor;BaseColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0.3301887,0,0,1;0.2264151,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;734;3706.125,1683.98;Inherit;True;3;3;0;FLOAT;1.91;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;844;7801.146,3071.748;Inherit;False;ErodingSpec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;831;8593.881,3083.961;Inherit;False;SpecBaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;845;5438.433,5105.836;Inherit;False;SpecAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;842;4201.53,5144.331;Inherit;False;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;913;5319.546,4690.085;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;559;5424.177,4462.461;Inherit;False;GradSpec;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;864;6880.569,4484.933;Inherit;False;800;LucencyAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;876;6800.488,3657.843;Inherit;False;874;LucencyAlphaAdjust;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;867;7050.188,3515.629;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;716;7636.502,3369.349;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;803;5672.696,3715.304;Inherit;False;799;BaseAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;819;5645.345,3394.938;Inherit;False;Erosion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;744;3397.245,3063.739;Inherit;False;Erodeval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;799;4359.115,2633.067;Inherit;False;BaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;899;3408.527,1905.208;Inherit;False;TranslucencySlider;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;874;4604.908,1535.573;Inherit;False;LucencyAlphaAdjust;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;800;4412.817,1862.497;Inherit;False;LucencyAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;565;4289.842,2226.273;Inherit;False;563;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;771;4582.001,2005.732;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;914;4963.139,2013.565;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;775;5093.223,1877.128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;766;2878.378,3978.033;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;668;2416.094,3844.003;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;1;[Normal];Create;True;0;0;0;False;0;False;-1;f4ae4efe9519bd6408a6e3b3dbe1194b;83453b2281268ce4f987266e417d65e8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;835;7062.718,3782.997;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;808;6818.958,3781.3;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;902;7930.369,4556.674;Inherit;False;899;TranslucencySlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;558;3045.472,4561.779;Inherit;False;Property;_Spec;Spec;1;0;Create;True;0;0;0;False;0;False;1;0.857;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;2861.24,3422.815;Inherit;False;Property;_Erode;Erode;0;0;Create;True;0;0;0;False;0;False;0;0.98;0;0.98;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;2982.746,2115.436;Inherit;True;744;Erodeval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;735;3078.837,1676.156;Inherit;False;Property;_Translucency;Translucency;7;0;Create;True;0;0;0;False;0;False;1;0.456;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;686;3180.56,3938.82;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;750;2870.421,3724.847;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;915;3233.379,3513.353;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;916;3508.379,3603.353;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;922;3283.379,3659.353;Inherit;False;Property;_Panner_Main;Panner_Main;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;923;1367.413,3832.348;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;924;1730.371,3620.854;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;926;2005.371,3710.854;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;927;1766.071,3820.155;Inherit;False;Property;_Panner_Normal;Panner_Normal;9;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureTransformNode;925;1408.371,3650.854;Inherit;False;668;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;917;2911.379,3543.353;Inherit;False;533;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
WireConnection;464;0;466;0
WireConnection;464;1;467;0
WireConnection;465;0;464;0
WireConnection;556;0;555;0
WireConnection;556;1;792;0
WireConnection;610;0;465;0
WireConnection;610;1;563;0
WireConnection;563;0;533;1
WireConnection;466;0;784;0
WireConnection;466;1;470;0
WireConnection;467;0;789;0
WireConnection;641;0;558;0
WireConnection;703;0;641;0
WireConnection;555;0;553;0
WireConnection;553;0;740;0
WireConnection;553;1;794;0
WireConnection;740;0;782;0
WireConnection;648;0;686;0
WireConnection;782;0;648;0
WireConnection;794;0;703;0
WireConnection;663;0;793;0
WireConnection;792;0;663;0
WireConnection;533;1;916;0
WireConnection;733;0;592;0
WireConnection;691;0;733;0
WireConnection;690;0;691;0
WireConnection;785;0;533;2
WireConnection;784;0;783;0
WireConnection;783;0;785;0
WireConnection;786;0;533;1
WireConnection;789;0;786;0
WireConnection;470;0;597;0
WireConnection;724;0;596;4
WireConnection;724;1;480;0
WireConnection;597;0;724;0
WireConnection;793;0;470;0
WireConnection;642;0;556;0
WireConnection;642;1;558;0
WireConnection;547;0;780;0
WireConnection;547;1;700;0
WireConnection;746;0;743;0
WireConnection;781;0;734;0
WireConnection;843;0;643;4
WireConnection;843;1;842;0
WireConnection;841;0;643;1
WireConnection;841;1;643;2
WireConnection;841;2;643;3
WireConnection;841;3;843;0
WireConnection;840;0;644;0
WireConnection;811;0;814;0
WireConnection;813;0;561;0
WireConnection;827;0;821;0
WireConnection;829;0;818;0
WireConnection;829;1;822;0
WireConnection;830;0;829;0
WireConnection;822;0;820;0
WireConnection;814;0;813;0
WireConnection;814;1;813;1
WireConnection;814;2;813;2
WireConnection;855;0;813;0
WireConnection;855;1;813;1
WireConnection;855;2;813;2
WireConnection;644;0;860;0
WireConnection;644;1;841;0
WireConnection;860;0;642;0
WireConnection;816;0;830;0
WireConnection;816;1;822;0
WireConnection;820;0;811;0
WireConnection;820;1;827;0
WireConnection;723;0;795;0
WireConnection;723;1;610;0
WireConnection;592;0;533;3
WireConnection;747;0;745;0
WireConnection;745;0;746;0
WireConnection;900;0;895;0
WireConnection;900;1;901;0
WireConnection;897;0;866;0
WireConnection;903;0;897;0
WireConnection;887;0;900;0
WireConnection;895;0;868;0
WireConnection;868;0;873;0
WireConnection;868;1;866;0
WireConnection;866;0;879;0
WireConnection;866;1;870;0
WireConnection;870;0;864;0
WireConnection;877;0;867;0
WireConnection;877;1;835;0
WireConnection;873;0;835;0
WireConnection;879;0;877;0
WireConnection;859;0;723;0
WireConnection;861;0;833;0
WireConnection;806;0;803;0
WireConnection;806;1;807;0
WireConnection;833;0;806;0
WireConnection;833;1;832;0
WireConnection;896;0;802;0
WireConnection;807;0;802;0
WireConnection;901;0;903;0
WireConnection;901;1;902;0
WireConnection;857;0;816;0
WireConnection;714;0;834;0
WireConnection;834;0;560;0
WireConnection;560;0;911;0
WireConnection;560;1;715;0
WireConnection;715;0;716;0
WireConnection;715;1;716;1
WireConnection;715;2;716;2
WireConnection;715;3;716;3
WireConnection;907;0;855;0
WireConnection;906;0;908;0
WireConnection;905;0;906;0
WireConnection;908;0;907;0
WireConnection;909;0;905;0
WireConnection;904;0;909;0
WireConnection;910;0;904;0
WireConnection;911;0;910;0
WireConnection;795;0;797;0
WireConnection;797;0;796;0
WireConnection;796;0;547;0
WireConnection;772;0;771;0
WireConnection;700;0;774;0
WireConnection;700;1;772;0
WireConnection;774;0;698;0
WireConnection;774;1;775;0
WireConnection;698;0;697;0
WireConnection;698;1;862;0
WireConnection;694;0;781;0
WireConnection;862;0;694;0
WireConnection;780;0;768;0
WireConnection;768;0;564;0
WireConnection;768;1;773;0
WireConnection;773;0;862;0
WireConnection;564;0;565;0
WireConnection;564;1;567;0
WireConnection;734;0;693;0
WireConnection;734;1;735;0
WireConnection;734;2;747;0
WireConnection;844;0;822;0
WireConnection;831;0;857;0
WireConnection;845;0;840;3
WireConnection;913;0;644;0
WireConnection;559;0;913;0
WireConnection;867;0;876;0
WireConnection;716;0;859;0
WireConnection;819;0;610;0
WireConnection;744;0;724;0
WireConnection;799;0;567;4
WireConnection;899;0;735;0
WireConnection;874;0;697;4
WireConnection;800;0;694;0
WireConnection;771;0;565;0
WireConnection;914;0;771;0
WireConnection;775;0;914;0
WireConnection;766;0;668;2
WireConnection;668;1;926;0
WireConnection;835;0;808;0
WireConnection;808;0;610;0
WireConnection;808;1;861;0
WireConnection;686;0;750;2
WireConnection;686;1;766;0
WireConnection;750;0;668;0
WireConnection;915;0;917;0
WireConnection;915;1;917;1
WireConnection;916;0;915;0
WireConnection;916;2;922;0
WireConnection;924;0;925;0
WireConnection;924;1;925;1
WireConnection;926;0;924;0
WireConnection;926;2;927;0
ASEEND*/
//CHKSM=06BADAAF0152EBF43E750D50B362BFD1D14410A4