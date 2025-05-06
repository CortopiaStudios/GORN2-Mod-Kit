// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_water_ripples"
{
	Properties
	{
		_RippleTex("_RippleTex", 2D) = "black" {}
		_Color0("Color 0", Color) = (0,0.9301295,1,0)
		_Caustics("Caustics", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			#include "Lighting.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Caustics;
			uniform sampler2D _RippleTex;
			uniform float4 _RippleTex_ST;
			uniform float4 _Color0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
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
				float2 texCoord39 = i.ase_texcoord1.xy * float2( 3,3 ) + float2( 0,0 );
				float mulTime46 = _Time.y * 0.1;
				float2 temp_cast_0 = (mulTime46).xx;
				float2 texCoord43 = i.ase_texcoord1.xy * float2( 3,3 ) + temp_cast_0;
				float2 uv_RippleTex = i.ase_texcoord1.xy * _RippleTex_ST.xy + _RippleTex_ST.zw;
				float4 tex2DNode1 = tex2D( _RippleTex, uv_RippleTex );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float clampResult29 = clamp( ( tex2DNode1.r * 6.0 ) , 0.2 , 0.8 );
				UnityGIInput data;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
				data.worldPos = WorldPosition;
				data.worldViewDir = ase_worldViewDir;
				data.probeHDR[0] = unity_SpecCube0_HDR;
				data.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
				data.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif //specdataif0
				#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
				data.boxMax[0] = unity_SpecCube0_BoxMax;
				data.probePosition[0] = unity_SpecCube0_ProbePosition;
				data.boxMax[1] = unity_SpecCube1_BoxMax;
				data.boxMin[1] = unity_SpecCube1_BoxMin;
				data.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif //specdataif1
				Unity_GlossyEnvironmentData g24 = UnityGlossyEnvironmentSetup( clampResult29, ase_worldViewDir, ase_worldNormal, float3(0,0,0));
				float3 indirectSpecular24 = UnityGI_IndirectSpecular( data, 0.2, ase_worldNormal, g24 );
				
				
				finalColor = ( ( tex2D( _Caustics, ( texCoord39 + ( ( tex2D( _Caustics, texCoord43 ).a * 0.1 ) * ( 1.0 - saturate( ( tex2DNode1.r * 5.0 ) ) ) ) ) ) * _Color0 ) + float4( indirectSpecular24 , 0.0 ) );
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
Node;AmplifyShaderEditor.SamplerNode;36;-229.3738,-820.7675;Inherit;True;Property;_Caustics;Caustics;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;247.4251,-724.7626;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-106.3448,-576.796;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0.9301295,1,0;0,0.9097543,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;23;819.762,-665.96;Float;False;True;-1;2;ASEMaterialInspector;100;5;ase_water_ripples;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-360.0534,-795.6733;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-592.3163,-668.8282;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-811.3055,-669.7581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1054.638,-280.2289;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1342.176,-155.7801;Inherit;True;Property;_RippleTex;_RippleTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;29;-386.3699,-316.8546;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-1123.189,-765.7183;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;36;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;46;-1633.114,-693.1189;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1364.983,-741.1187;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;14;-763.4421,-556.3023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-915.2305,-416.0751;Inherit;False;1;0;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-664.6097,-795.579;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;25;599.3029,-689.3334;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-907.2437,-132.8349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;24;-125.9526,-342.8127;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.92;False;2;FLOAT;0.2;False;1;FLOAT3;0
WireConnection;36;1;44;0
WireConnection;37;0;36;0
WireConnection;37;1;2;0
WireConnection;23;0;25;0
WireConnection;44;0;39;0
WireConnection;44;1;50;0
WireConnection;50;0;45;0
WireConnection;50;1;14;0
WireConnection;45;0;47;4
WireConnection;56;0;1;1
WireConnection;29;0;57;0
WireConnection;47;1;43;0
WireConnection;43;1;46;0
WireConnection;14;0;33;0
WireConnection;33;0;56;0
WireConnection;25;0;37;0
WireConnection;25;1;24;0
WireConnection;57;0;1;1
WireConnection;24;1;29;0
ASEEND*/
//CHKSM=47FA149F84A673153C4F7A175C5237B035590D69