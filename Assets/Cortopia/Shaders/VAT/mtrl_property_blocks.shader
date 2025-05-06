// Upgrade NOTE: upgraded instancing buffer 'mtrl_property_blocks' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "mtrl_property_blocks"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Offset("Offset", Vector) = (0,0,0,0)
		_Color("_Color", Color) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;

		UNITY_INSTANCING_BUFFER_START(mtrl_property_blocks)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr mtrl_property_blocks
			UNITY_DEFINE_INSTANCED_PROP(float2, _Tiling)
#define _Tiling_arr mtrl_property_blocks
			UNITY_DEFINE_INSTANCED_PROP(float2, _Offset)
#define _Offset_arr mtrl_property_blocks
		UNITY_INSTANCING_BUFFER_END(mtrl_property_blocks)

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float2 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float2 _Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Offset_arr, _Offset);
			float2 uv_TexCoord7 = i.uv_texcoord * _Tiling_Instance + _Offset_Instance;
			o.Emission = ( _Color_Instance * tex2D( _TextureSample0, uv_TexCoord7 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SamplerNode;2;-162.5,-108;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;2e021c505ffec3c4b91ddf51d3c0f75d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-430.5,-78;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;157.5,-127;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;12;-133.5,-318;Inherit;False;InstancedProperty;_Color;_Color;3;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-675.5,22;Inherit;False;InstancedProperty;_Offset;Offset;2;0;Create;True;0;0;0;False;0;False;0,0;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;9;-675.5,-140;Inherit;False;InstancedProperty;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;1,1;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;310,-176;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;mtrl_property_blocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;1;7;0
WireConnection;7;0;9;0
WireConnection;7;1;11;0
WireConnection;13;0;12;0
WireConnection;13;1;2;0
WireConnection;0;2;13;0
ASEEND*/
//CHKSM=DA3041DE8584BBAE9357BCE4EC156EDB03FD794A