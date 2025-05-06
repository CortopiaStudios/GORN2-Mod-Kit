// Upgrade NOTE: upgraded instancing buffer 'ase_brain_boss' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_brain_boss"
{
	Properties
	{
		_AlbedoSmoothness("Albedo Smoothness", 2D) = "white" {}
		[Toggle(_NORMALMAPENABLED_ON)] _NormalmapEnabled("Normalmap Enabled", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		_Damage("Damage", Float) = 0
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
		#pragma shader_feature_local _NORMALMAPENABLED_ON
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _AlbedoSmoothness;

		UNITY_INSTANCING_BUFFER_START(ase_brain_boss)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Normal_ST)
#define _Normal_ST_arr ase_brain_boss
			UNITY_DEFINE_INSTANCED_PROP(float4, _AlbedoSmoothness_ST)
#define _AlbedoSmoothness_ST_arr ase_brain_boss
			UNITY_DEFINE_INSTANCED_PROP(float, _Damage)
#define _Damage_arr ase_brain_boss
		UNITY_INSTANCING_BUFFER_END(ase_brain_boss)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Normal_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Normal_ST_arr, _Normal_ST);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST_Instance.xy + _Normal_ST_Instance.zw;
			#ifdef _NORMALMAPENABLED_ON
				float3 staticSwitch3 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			#else
				float3 staticSwitch3 = float3(0,0,1);
			#endif
			o.Normal = staticSwitch3;
			float4 _AlbedoSmoothness_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_AlbedoSmoothness_ST_arr, _AlbedoSmoothness_ST);
			float2 uv_AlbedoSmoothness = i.uv_texcoord * _AlbedoSmoothness_ST_Instance.xy + _AlbedoSmoothness_ST_Instance.zw;
			float4 tex2DNode1 = tex2D( _AlbedoSmoothness, uv_AlbedoSmoothness );
			o.Albedo = tex2DNode1.rgb;
			float4 color22 = IsGammaSpace() ? float4(0.7450981,0,0,0) : float4(0.5149179,0,0,0);
			float _Damage_Instance = UNITY_ACCESS_INSTANCED_PROP(_Damage_arr, _Damage);
			o.Emission = saturate( ( color22 * _Damage_Instance ) ).rgb;
			o.Metallic = i.vertexColor.r;
			o.Smoothness = tex2DNode1.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.Vector3Node;2;-450.8333,-952.3466;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-552.8333,-790.5569;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;3;-160.8333,-700.3466;Inherit;False;Property;_NormalmapEnabled;Normalmap Enabled;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-590,-581.5;Inherit;True;Property;_AlbedoSmoothness;Albedo Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;385,-578;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_brain_boss;False;False;False;False;False;False;True;True;True;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.WireNode;19;1.75,-463.6973;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;18;-128.25,-367.6973;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;6;-473.5,-386.75;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;20;147.9047,-396.2725;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;16.90472,-311.2725;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-240.7142,-258.9705;Inherit;False;Constant;_Color1;Color 0;13;0;Create;True;0;0;0;False;0;False;0.7450981,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-229.0953,-88.27251;Inherit;False;InstancedProperty;_Damage;Damage;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;3;1;2;0
WireConnection;3;0;4;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;2;20;0
WireConnection;0;3;19;0
WireConnection;0;4;1;4
WireConnection;19;0;18;0
WireConnection;18;0;6;1
WireConnection;20;0;21;0
WireConnection;21;0;22;0
WireConnection;21;1;23;0
ASEEND*/
//CHKSM=C102292CDFA16D40579E74EC794A49A582512723