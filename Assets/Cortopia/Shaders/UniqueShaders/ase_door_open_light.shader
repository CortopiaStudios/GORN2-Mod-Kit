// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_door_open_light"
{
	Properties
	{
		_DoorOpens("DoorOpens", Range( 0 , 1)) = 0
		_TEX_CloudNoise("TEX_CloudNoise", 2D) = "white" {}
		_ColorRays("ColorRays", Color) = (0.4764151,0.6845875,1,0)
		[HDR]_HDRColor("HDR Color", Color) = (0.4764151,0.6845875,1,0)

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
		ColorMask RGB
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TEX_CloudNoise;
			uniform float4 _ColorRays;
			uniform float4 _HDRColor;
			uniform float _DoorOpens;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

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
				float mulTime19 = _Time.y * 0.01;
				float2 temp_cast_0 = ((WorldPosition.y*0.2 + mulTime19)).xx;
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult10 = smoothstep( 0.0 , 1.0 , texCoord2.y);
				float4 lerpResult4 = lerp( saturate( ( ( ( ( tex2D( _TEX_CloudNoise, temp_cast_0 ) * smoothstepResult10 ) * _ColorRays ) + smoothstepResult10 ) * _HDRColor ) ) , float4( 0,0,0,0 ) , saturate( ( (0.0 + (_DoorOpens - 1.0) * (20.0 - 0.0) / (0.0 - 1.0)) * texCoord2.x ) ));
				
				
				finalColor = lerpResult4;
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-76,-217.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-16,-744.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;10;-155,-581.5;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-299,-400.5;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;357,-653.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;8;358,-234.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-636,-237.5;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-686,-404.5;Inherit;False;Property;_DoorOpens;DoorOpens;0;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;719,-350.5;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-454.756,-743.5697;Inherit;True;Property;_TEX_CloudNoise;TEX_CloudNoise;1;0;Create;True;0;0;0;False;0;False;-1;21b46c6e6bfb16e4abfced00ad9152cd;21b46c6e6bfb16e4abfced00ad9152cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;28;-690.2255,-715.9291;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-925.5068,-765.0471;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;19;-929.9999,-588.7905;Inherit;False;1;0;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;165,-714.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;23;616.0459,-556.9965;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;432.8199,-490.3886;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-90,-444.5;Inherit;False;Property;_ColorRays;ColorRays;2;0;Create;True;0;0;0;False;0;False;0.4764151,0.6845875,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;153.6527,-395.6487;Inherit;False;Property;_HDRColor;HDR Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0.4764151,0.6845875,1,0;0.4575472,1,0.8027445,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1198.95,-360.3221;Float;False;True;-1;2;ASEMaterialInspector;100;5;ase_door_open_light;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;True;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;5;0;14;0
WireConnection;5;1;2;1
WireConnection;18;0;15;0
WireConnection;18;1;10;0
WireConnection;10;0;2;2
WireConnection;14;0;6;0
WireConnection;20;0;21;0
WireConnection;20;1;10;0
WireConnection;8;0;5;0
WireConnection;4;0;23;0
WireConnection;4;2;8;0
WireConnection;15;1;28;0
WireConnection;28;0;25;2
WireConnection;28;2;19;0
WireConnection;21;0;18;0
WireConnection;21;1;22;0
WireConnection;23;0;29;0
WireConnection;29;0;20;0
WireConnection;29;1;30;0
WireConnection;0;0;4;0
ASEEND*/
//CHKSM=FB9EF0D8E0335A8C678037E7F15DC53CE948AE65