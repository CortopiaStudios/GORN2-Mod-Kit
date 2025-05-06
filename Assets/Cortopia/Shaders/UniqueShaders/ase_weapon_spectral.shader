// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_weapon_spectral"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,1,0.9607843,1)
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_Power("Power", Float) = 1
		_Noise("Noise", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
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

			uniform half _Bias;
			uniform half _Scale;
			uniform half _Power;
			uniform half4 _Color0;
			uniform sampler2D _Noise;

			
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
				half fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode3 = ( _Bias + _Scale * pow( max( 1.0 - fresnelNdotV3 , 0.0001 ), _Power ) );
				half temp_output_60_0 = saturate( ( 1.0 - fresnelNode3 ) );
				half2 appendResult86 = (half2(WorldPosition.y , WorldPosition.z));
				half mulTime81 = _Time.y * 0.1;
				half2 appendResult87 = (half2(mulTime81 , 0.0));
				
				
				finalColor = ( ( temp_output_60_0 * ( temp_output_60_0 + _Color0 ) ) * tex2D( _Noise, (appendResult86*1.0 + appendResult87) ) );
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
Node;AmplifyShaderEditor.FresnelNode;3;-567.3156,-285.5883;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-814.3467,-278.4942;Inherit;False;Property;_Bias;Bias;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-805.449,-110.0842;Inherit;False;Property;_Power;Power;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-820.449,-203.0841;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;667.6665,-296.8221;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;53;1084.152,-298.8529;Half;False;True;-1;2;ASEMaterialInspector;100;5;ase_weapon_spectral;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;515.8521,-37.83752;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;859.8521,-289.8375;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;59;-244.2942,-281.8675;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;710.8521,212.1625;Inherit;True;Property;_Noise;Noise;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;85;453.8521,235.1625;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;60;-81.08765,-283.0766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-57.14795,-79.83752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;467.2432,-186.367;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;2,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;81;-72.14795,387.1625;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;87;217.8521,376.1625;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;76;12.6665,294.1779;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;199.8521,183.1625;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;11;170.771,-20.21948;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,1,0.9607843,1;0.7490196,0.138933,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;83;-1.147949,136.1625;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
WireConnection;3;1;55;0
WireConnection;3;2;73;0
WireConnection;3;3;74;0
WireConnection;77;0;60;0
WireConnection;77;1;54;0
WireConnection;53;0;82;0
WireConnection;78;0;60;0
WireConnection;78;1;11;0
WireConnection;82;0;77;0
WireConnection;82;1;79;0
WireConnection;59;0;3;0
WireConnection;79;1;85;0
WireConnection;85;0;86;0
WireConnection;85;1;76;0
WireConnection;85;2;87;0
WireConnection;60;0;59;0
WireConnection;54;0;60;0
WireConnection;54;1;11;0
WireConnection;87;0;81;0
WireConnection;86;0;83;2
WireConnection;86;1;83;3
ASEEND*/
//CHKSM=9CAF13EF56DA913EF461AADE81CDCC2CC2A08478