// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TexturePaintLineShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}

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
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest Always
		Offset 0 , 0
		
		
		
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#include "paint_particles.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float4 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			float4 PaintLineColorLoop87( float4 MainTex, float3 WorldPos, float3 WorldNormal, float facingThreshold, float maxProjectionOffset, float minProjectionOffset )
			{
				float4 result = MainTex;
				for(int i=0; i<_ParticleCount; i++) {
				    float3 A = _ParticlePositions[i];
				    float3 B = _ParticleEndPositions[i];
				    float3 normal =  normalize(_ParticleNormals[i]);
				    // Calculate distance to line
				    float3 AB = B - A;
				    float3 AP = A - WorldPos;
				 
				    // Calculate perpendicular line
				    float3 PN = cross(AB, normal);
				        
				    // Calculate the scalars for AB and Pnormal
				    float x = -dot(cross(AP, normal), PN) / dot(PN, PN);
				    float y = -dot(cross(AP, AB), PN) / dot(PN, PN);
				    // Closest points on each line
				    x = clamp(x, 0.0, 1.0);
				    y = clamp(y, minProjectionOffset, maxProjectionOffset);
				    float3 closestPoint1 = A + x * AB;
				    float3 closestPoint2 = WorldPos + y * normal;
				    float dist = distance(closestPoint1,closestPoint2);
				    // Only paint on pixels facing the slash
				    float facingFactor = step(facingThreshold, dot(WorldNormal, normal));
				    // Smooth transition for line edges using smoothstep
				    float radius = _ParticleRadius[i];
				    float radiusHardness = radius * _ParticleHardness[i];
				    float smooth = smoothstep(radiusHardness, radius, dist);
				    
				    // Control line strength and alpha blending for smooth fade
				    float fadeFactor = (1.0 - smooth) * facingFactor * _ParticleStrength[i];
				    float4 lerpResult = lerp(float4(0, 0, 0, 0), _ParticleColors[i], fadeFactor);
				    // Add line result to final texture
				    result += lerpResult;
				}
				return result;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 texCoord5 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult8 = (float2(1.0 , _ProjectionParams.x));
				float2 break31 = ( ( ( texCoord5 * float2( 2,2 ) ) - float2( 1,1 ) ) * appendResult8 );
				float4 appendResult32 = (float4(break31.x , break31.y , 0.0 , 1.0));
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float4 vertexValue = appendResult32;
				o.vertex = vertexValue;

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				#endif
				return o;
			}
			
			float4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				float4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord5 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 MainTex87 = tex2D( _MainTex, texCoord5 );
				float3 WorldPos87 = WorldPosition;
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 WorldNormal87 = ase_worldNormal;
				float facingThreshold87 = 0.2;
				float maxProjectionOffset87 = 0.3;
				float minProjectionOffset87 = -0.2;
				float4 localPaintLineColorLoop87 = PaintLineColorLoop87( MainTex87 , WorldPos87 , WorldNormal87 , facingThreshold87 , maxProjectionOffset87 , minProjectionOffset87 );
				
				
				finalColor = localPaintLineColorLoop87;
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-526.3434,49.5853;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-379.0824,30.26871;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;223.1773,-8.132874;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;31;-28.83842,12.58073;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-204.6739,149.0064;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-528.3434,180.5853;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ProjectionParams;6;-788.0169,195.7216;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-808.6955,-239.4049;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-199.2539,-656.8901;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-95.92355,-462.8936;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;75;-92.83208,-309.5367;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;84;126.3306,-193.4861;Inherit;False;Constant;_MinProjectionOffset;MinProjectionOffset;1;0;Create;True;0;0;0;False;0;False;-0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;123.7104,-266.4047;Inherit;False;Constant;_MaxProjectionOffset;MaxProjectionOffset;1;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;45;847.9532,-131.8948;Float;False;True;-1;2;ASEMaterialInspector;100;12;TexturePaintLineShader;3db92839211cf6048bd4cdeaca52ecc2;True;Blood;0;0;Blood;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;7;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;2;Include;;False;;Native;False;0;0;;Include;paint_particles.cginc;False;;Custom;False;0;0;;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-123.1625,-158.4048;Inherit;False;Constant;_FacingThreshold;FacingThreshold;1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;87;462.0256,-597.6017;Inherit;False;float4 result = MainTex@$$for(int i=0@ i<_ParticleCount@ i++) {$$    float3 A = _ParticlePositions[i]@$    float3 B = _ParticleEndPositions[i]@$    float3 normal =  normalize(_ParticleNormals[i])@$$    // Calculate distance to line$    float3 AB = B - A@$    float3 AP = A - WorldPos@$ $    // Calculate perpendicular line$    float3 PN = cross(AB, normal)@$        $    // Calculate the scalars for AB and Pnormal$    float x = -dot(cross(AP, normal), PN) / dot(PN, PN)@$    float y = -dot(cross(AP, AB), PN) / dot(PN, PN)@$$    // Closest points on each line$    x = clamp(x, 0.0, 1.0)@$    y = clamp(y, minProjectionOffset, maxProjectionOffset)@$    float3 closestPoint1 = A + x * AB@$    float3 closestPoint2 = WorldPos + y * normal@$    float dist = distance(closestPoint1,closestPoint2)@$$    // Only paint on pixels facing the slash$    float facingFactor = step(facingThreshold, dot(WorldNormal, normal))@$$    // Smooth transition for line edges using smoothstep$    float radius = _ParticleRadius[i]@$    float radiusHardness = radius * _ParticleHardness[i]@$    float smooth = smoothstep(radiusHardness, radius, dist)@$    $    // Control line strength and alpha blending for smooth fade$    float fadeFactor = (1.0 - smooth) * facingFactor * _ParticleStrength[i]@$    float4 lerpResult = lerp(float4(0, 0, 0, 0), _ParticleColors[i], fadeFactor)@$$    // Add line result to final texture$    result += lerpResult@$}$return result@;4;Create;6;True;MainTex;FLOAT4;0,0,0,0;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Inherit;False;True;WorldNormal;FLOAT3;0,0,0;In;;Inherit;False;True;facingThreshold;FLOAT;0.5;In;;Inherit;False;True;maxProjectionOffset;FLOAT;0;In;;Inherit;False;True;minProjectionOffset;FLOAT;0;In;;Inherit;False;Paint Line Color Loop;True;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.5;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT4;0
WireConnection;9;0;5;0
WireConnection;10;0;9;0
WireConnection;32;0;31;0
WireConnection;32;1;31;1
WireConnection;31;0;12;0
WireConnection;12;0;10;0
WireConnection;12;1;8;0
WireConnection;8;1;6;1
WireConnection;15;1;5;0
WireConnection;45;0;87;0
WireConnection;45;1;32;0
WireConnection;87;0;15;0
WireConnection;87;1;17;0
WireConnection;87;2;75;0
WireConnection;87;3;81;0
WireConnection;87;4;83;0
WireConnection;87;5;84;0
ASEEND*/
//CHKSM=D3C818815A8AC004D3CEC54A164BA2EE1500DFFD