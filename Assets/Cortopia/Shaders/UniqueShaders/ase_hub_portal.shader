// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_hub_portal"
{
	Properties
	{
		_ParallaxTexture1("Parallax Texture 1", 2D) = "white" {}
		_Swirl("Swirl", 2D) = "white" {}
		_BiomeColor("BiomeColor", Color) = (0.972549,0.4534461,0.08627448,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
			half3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _ParallaxTexture1;
		uniform sampler2D _Swirl;
		uniform half4 _BiomeColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord168 = i.uv_texcoord * half2( 0.03,0.03 ) + half2( 0.5,0.5 );
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			half3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			half2 Offset179 = ( ( 0.3 - 1 ) * ase_tanViewDir.xy * 0.7 ) + uv_TexCoord168;
			float2 uv_TexCoord164 = i.uv_texcoord * half2( 0.5,0.5 ) + half2( 0.25,0.25 );
			half2 Offset166 = ( ( 0.4 - 1 ) * ase_tanViewDir.xy * 0.6 ) + uv_TexCoord164;
			float cos210 = cos( -0.4 * _Time.y );
			float sin210 = sin( -0.4 * _Time.y );
			half2 rotator210 = mul( Offset166 - float2( 0.5,0.5 ) , float2x2( cos210 , -sin210 , sin210 , cos210 )) + float2( 0.5,0.5 );
			float cos209 = cos( -0.3 * _Time.y );
			float sin209 = sin( -0.3 * _Time.y );
			half2 rotator209 = mul( Offset166 - float2( 0.5,0.5 ) , float2x2( cos209 , -sin209 , sin209 , cos209 )) + float2( 0.5,0.5 );
			half4 temp_output_167_0 = ( ( tex2D( _Swirl, rotator210 ) * 0.5 ) + ( 0.5 * tex2D( _Swirl, rotator209 ) ) );
			half smoothstepResult189 = smoothstep( 0.3 , 0.4 , distance( ( Offset166 + float2( -0.5,-0.5 ) ) , float2( 0,0 ) ));
			o.Emission = ( tex2D( _ParallaxTexture1, ( half4( Offset179, 0.0 , 0.0 ) + ( 0.02 * temp_output_167_0 ) ).rg ) + ( ( temp_output_167_0 + _BiomeColor ) * saturate( ( ( _BiomeColor * 0.2 ) + smoothstepResult189 ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.RangedFloatNode;159;-1887.693,-158.9726;Inherit;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-1715.064,-87.78842;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0.5,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;209;-2408.3,-35.12313;Inherit;False;3;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;-0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;210;-2402.733,-233.5572;Inherit;False;3;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;-0.4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;181;-2171.039,-61.60961;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;daf765042a55b274dbf86202d52ae37b;True;0;False;white;LockedToTexture2D;False;Instance;208;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;177;-1476.476,-150.3304;Inherit;False;Property;_BiomeColor;BiomeColor;2;0;Create;True;0;0;0;False;0;False;0.972549,0.4534461,0.08627448,0;1,0.9375753,0.7882353,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;187;-1418.954,16.40005;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;173;-1753.341,92.38228;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;171;-2294.774,90.33348;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-1199.091,-149.3823;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-1713.828,-254.5824;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-1233.835,-254.8326;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;194;-1038.564,-149.7672;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;189;-1305.873,91.71558;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;157;-3491.611,-237.9737;Inherit;False;Constant;_OffsetSwirl2;OffsetSwirl2;4;0;Create;True;0;0;0;False;0;False;0.25,0.25;0.25,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;158;-3499.611,-367.9739;Inherit;False;Constant;_TilingSwirl2;TilingSwirl2;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;161;-3210.24,82.32069;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;162;-3233.019,-78.64409;Inherit;False;Constant;_SwirlHeight2;SwirlHeight2;3;0;Create;True;0;0;0;False;0;False;0.4;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-3129.02,6.080011;Inherit;False;Constant;_SwirlScale2;SwirlScale2;3;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;164;-3200.881,-216.064;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0.25,0.25;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;166;-2745.592,-34.04508;Inherit;False;Normal;4;0;FLOAT2;1,1;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;193;-901.6539,-150.3158;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-717.9452,-252.3514;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-468.0079,-276.1365;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;197;-800.2244,-447.8745;Inherit;True;Property;_ParallaxTexture1;Parallax Texture 1;0;0;Create;True;0;0;0;False;0;False;-1;None;a13cf53b0787bee4c99e64a0a1bb6e64;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;199;-941.0386,-422.8055;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-1228.733,-359.8326;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;165;-2108.825,-556.8056;Inherit;False;Constant;_Offset;Offset;6;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.48;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;168;-1781.74,-714.9952;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.03,0.03;False;1;FLOAT2;0.5,0.45;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;170;-2108.825,-688.8055;Inherit;False;Constant;_Tiling;Tiling;6;0;Create;True;0;0;0;False;0;False;0.03,0.03;0.015,0.015;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ParallaxMappingNode;179;-1451.214,-564.2037;Inherit;False;Normal;4;0;FLOAT2;1,1;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-1805.752,-489.9624;Inherit;False;Constant;_BackgroundScale;BackgroundScale;4;0;Create;True;0;0;0;False;0;False;0.7;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-1812.256,-569.3789;Inherit;False;Constant;_BackgroundHeight;BackgroundHeight;5;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;169;-1737.791,-410.2689;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;212;-1448.427,-358.738;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;208;-2165.234,-257.4307;Inherit;True;Property;_Swirl;Swirl;1;0;Create;True;0;0;0;False;0;False;-1;None;daf765042a55b274dbf86202d52ae37b;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-1493.907,-254.3316;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-1533.261,148.038;Inherit;False;Constant;_Min;Min;4;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;215;-298.4714,-324.9605;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_hub_portal;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-1530.261,223.038;Inherit;False;Constant;_Max;Max;4;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
WireConnection;160;0;159;0
WireConnection;160;1;181;0
WireConnection;209;0;166;0
WireConnection;210;0;166;0
WireConnection;181;1;209;0
WireConnection;173;0;171;0
WireConnection;171;0;166;0
WireConnection;186;0;177;0
WireConnection;186;1;187;0
WireConnection;172;0;208;0
WireConnection;172;1;159;0
WireConnection;176;0;167;0
WireConnection;176;1;177;0
WireConnection;194;0;186;0
WireConnection;194;1;189;0
WireConnection;189;0;173;0
WireConnection;189;1;214;0
WireConnection;189;2;213;0
WireConnection;164;0;158;0
WireConnection;164;1;157;0
WireConnection;166;0;164;0
WireConnection;166;1;162;0
WireConnection;166;2;163;0
WireConnection;166;3;161;0
WireConnection;193;0;194;0
WireConnection;191;0;176;0
WireConnection;191;1;193;0
WireConnection;185;0;197;0
WireConnection;185;1;191;0
WireConnection;197;1;199;0
WireConnection;199;0;179;0
WireConnection;199;1;200;0
WireConnection;200;0;212;0
WireConnection;200;1;167;0
WireConnection;168;0;170;0
WireConnection;168;1;165;0
WireConnection;179;0;168;0
WireConnection;179;1;182;0
WireConnection;179;2;180;0
WireConnection;179;3;169;0
WireConnection;208;1;210;0
WireConnection;167;0;172;0
WireConnection;167;1;160;0
WireConnection;215;2;185;0
ASEEND*/
//CHKSM=AF9BD8B7B9BAC055B3B8D2E08F4508D687AF8F3D