// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_lava_floor"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_Swirl("Swirl", Float) = 0.007
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _MainTex;
		uniform float _Swirl;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_68_0 = (ase_worldPos).xz;
			float mulTime58 = _Time.y * 0.6;
			o.Emission = tex2D( _MainTex, ( ( temp_output_68_0 * 0.2 ) + tex2D( _MainTex, ( ( temp_output_68_0 * _Swirl ) + ( mulTime58 * 0.001 ) ) ).r ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-2155.641,-255.3175;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1443.754,-300.8879;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;75;-2777.218,-469.5273;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1871.439,-515.7803;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;67;-3333.237,-298.7809;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-2382.641,-167.6178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-2020.763,-279.3625;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;9;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-2778.236,-223.4809;Inherit;False;Property;_Swirl;Swirl;1;0;Create;True;0;0;0;False;0;False;0.007;0.004;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;68;-3121.136,-305.5811;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-1224.418,-318.2536;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;4e6915e0c45f8a04da3fa7fe4663721a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;15;-882.8941,-363.106;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_lava_floor;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2087.726,-438.3806;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2530.935,-308.6809;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;58;-2567.341,-168.6178;Inherit;False;1;0;FLOAT;0.6;False;1;FLOAT;0
WireConnection;61;0;71;0
WireConnection;61;1;60;0
WireConnection;22;0;69;0
WireConnection;22;1;34;1
WireConnection;75;0;68;0
WireConnection;69;0;75;0
WireConnection;69;1;70;0
WireConnection;60;0;58;0
WireConnection;34;1;61;0
WireConnection;68;0;67;0
WireConnection;9;1;22;0
WireConnection;15;2;9;0
WireConnection;71;0;68;0
WireConnection;71;1;72;0
ASEEND*/
//CHKSM=426C9F3716A70F3F38389C03459C1C1B9138BE14