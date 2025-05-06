// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_armor_dents_vfx"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_DentsNormal("Dents Normal", 2D) = "bump" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		_DentsNormalTilingStandardShader("Dents Normal Tiling (Standard Shader)", Vector) = (3,3,0,0)
		_Blood_RDents_G("Blood_R Dents_G", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _ISMETALLIC_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred nolightmap  nodynlightmap nodirlightmap nofog noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _DentsNormal;
		uniform float2 _DentsNormalTilingStandardShader;
		uniform sampler2D _Blood_RDents_G;
		uniform sampler2D _Albedo_Smoothness;
		uniform float4 _Albedo_Smoothness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord271 = i.uv_texcoord * _DentsNormalTilingStandardShader;
			o.Normal = UnpackNormal( tex2D( _DentsNormal, uv_TexCoord271 ) );
			float4 tex2DNode323 = tex2D( _Blood_RDents_G, uv_TexCoord271 );
			float2 uv_Albedo_Smoothness = i.uv_texcoord * _Albedo_Smoothness_ST.xy + _Albedo_Smoothness_ST.zw;
			float4 tex2DNode153 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
			o.Albedo = ( tex2DNode323.a * tex2DNode153 ).rgb;
			#ifdef _ISMETALLIC_ON
				float staticSwitch3_g12 = i.vertexColor.r;
			#else
				float staticSwitch3_g12 = 0.0;
			#endif
			o.Metallic = staticSwitch3_g12;
			o.Smoothness = ( tex2DNode323.a * tex2DNode153.a );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;822.65,-797.1302;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cortopia/ase_armor_dents_vfx;False;False;False;False;False;False;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;388.8182,-1023.287;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;70;-84.88785,-722.4063;Inherit;False;ase_function_metallic;2;;12;6f2bdb1e1a920ec409d1c604a9c39837;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;322.9845,-666.1957;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;153;-432.2396,-767.9209;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;271;-442.717,-907.821;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;272;-779.5297,-884.644;Inherit;False;Property;_DentsNormalTilingStandardShader;Dents Normal Tiling (Standard Shader);4;0;Create;True;0;0;0;False;0;False;3,3;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;323;-126.0156,-1086.196;Inherit;True;Property;_Blood_RDents_G;Blood_R Dents_G;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;156;309.3559,-881.3867;Inherit;True;Property;_DentsNormal;Dents Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;322;0
WireConnection;0;1;156;0
WireConnection;0;3;70;0
WireConnection;0;4;324;0
WireConnection;322;0;323;4
WireConnection;322;1;153;0
WireConnection;324;0;323;4
WireConnection;324;1;153;4
WireConnection;271;0;272;0
WireConnection;323;1;271;0
WireConnection;156;1;271;0
ASEEND*/
//CHKSM=681AA58116E79AAB51EEB0D06A6E2D2BC4B6207E